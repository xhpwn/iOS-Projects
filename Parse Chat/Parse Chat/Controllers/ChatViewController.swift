//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Anubhav Saxena on 2/5/18.
//  Copyright © 2018 Anubhav Saxena. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    
    var messages: [PFObject]?
    
    class Message: PFObject, PFSubclassing {
        
        static func parseClassName() -> String {
            return "Message"
        }
        
        @NSManaged var user: String
        @NSManaged var message: String
        
    }
    
    
    @IBAction func trySendingMessage(_ sender: Any) {
        sendMessage()
        messageField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.dataSource = self
        chatTableView.delegate = self
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        chatTableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendMessage() {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
        cell.selectionStyle = .none
        let eachMessage = messages?[indexPath.row] as! Message?
        cell.messageLabel.text = eachMessage?.message
        cell.usernameLabel.text = eachMessage?.user
        return cell
    }

    @objc func onTimer() {
        print("timer works")
        fetchMessages()
    }
    
    func fetchMessages() {
        var query = Message.query()
        query?.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                // do something with the array of object returned by the call
                self.messages = posts
                self.chatTableView.reloadData();
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
