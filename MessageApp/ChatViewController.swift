//
//  ChatViewController.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 9/27/18.
//  Copyright © 2018 Sharon  Macasaol. All rights reserved.
//
import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var messageArr: [Message] = []
    var db: Firestore!
    
    @IBOutlet weak var chatFieldView: UIView!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let today = Date()
        today.toString(dateFormat: "dd-MM")
        var ref: DocumentReference? = nil
        ref = db.collection("sdsdsmessages").addDocument(data: [
            "username": "",
            "password":  "",
            "id": ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //firebase config
        let settings = FirestoreSettings()
        settings.areTimestampsInSnapshotsEnabled = true
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        db.settings = settings
        
        self.chatTable.dataSource = self
        self.chatTable.delegate = self
        
        self.headerView.logoutBtn.addTarget(self, action: #selector(logoutApp), for: .touchUpInside)

        self.headerView.logoutView.isHidden = false
        retrieveMessages()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatAppTableViewCell
        cell.messageLbl.text = messageArr[indexPath.row].userMessage
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 5
        return cell
    }
    
    func retrieveMessages() {
        let db = Firestore.firestore()
        // [START listen_to_offline]
        // Listen to metadata updates to receive a server snapshot even if
        // the data is the same as the cached data.
        db.collection("messages")
            .addSnapshotListener(includeMetadataChanges: true) { queryMessage, error in
                guard let messageArr = queryMessage else {
                    print("Error retreiving snapshot: \(error!)")
                    return
                }
                
                for diff in messageArr.documentChanges {
                    if diff.type == .added {
                        let message = diff.document.data()
                        self.messageArr.append(Message(userId: message["userId"] as? String, userName: message["name"] as? String, userMessage: message["message"] as? String))
                        self.chatTable.reloadData()
                    }
                }
        }
    }
    
    @objc func logoutApp() {
        let sb = UIStoryboard.init(name: "SignUp", bundle: nil)
        let modal = sb.instantiateViewController(withIdentifier: "signup_login") as! SignUpViewController
        modal.actionType = 1
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(modal, animated: true, completion: nil)
        }
    }
    

}
