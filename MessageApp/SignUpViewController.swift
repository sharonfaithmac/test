//
//  SignUpViewController.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 9/26/18.
//  Copyright © 2018 Sharon  Macasaol. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var actionType: Int?
    var db: Firestore!
    var isError: Bool?
    
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    //warning views height constraint
    @IBOutlet weak var usernameWarningConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordWarningHeightConstraint: NSLayoutConstraint!
    
    //warning labels
    @IBOutlet weak var usernameWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    
    @IBAction func submit(_ sender: UIButton) {
        
        isError = false
        
        guard
            let nameField = self.usernameText,
            let passwordField = self.passwordText else {
            return
        }
        
        if nameField.text?.trim().count == 0 {
            isError = true
            usernameWarningLabel.isHidden = false
            usernameWarningConstraint.constant = 30
        } else {
            usernameWarningLabel.isHidden = true
            usernameWarningConstraint.constant = 20
        }
        
        if passwordField.text?.trim().count == 0 {
            isError = true
            passwordWarningLabel.isHidden = false
            passwordWarningHeightConstraint.constant = 30
        } else {
            passwordWarningLabel.isHidden = true
            usernameWarningConstraint.constant = 20
            
        }
        
        if isError! {
            return
        }
        
        if actionType == homeAction.login.rawValue {
            let db = Firestore.firestore()
            // [START listen_to_offline]
            // Listen to metadata updates to receive a server snapshot even if
            // the data is the same as the cached data.
            db.collection("users").whereField("username", isEqualTo: nameField.text ?? " ").whereField("password", isEqualTo: passwordField.text ?? " ").limit(to: 1)
                .addSnapshotListener(includeMetadataChanges: true) { queryUser, error in
                    guard let userArr = queryUser else {
                        print("Error retreiving snapshot: \(error!)")
                        return
                    }
                    
                    for diff in userArr.documentChanges {
                        if diff.type == .added {
                            let userInfo = diff.document.data()
                            print("Username: \(diff.document.data())")
                            UserMessage.shared.loggedInUser = User(id: userInfo["id"] as? String ?? "", username: userInfo["username"] as? String ?? "")
                            self.presentChatView()
                        }
                    }
                    
                    let source = userArr.metadata.isFromCache ? "local cache" : "server"
                    print("Metadata: Data fetched from \(source)")
            }
            
        } else {
            var ref: DocumentReference? = nil
            let generateUserRandId = self.randomString(length: 10)
            ref = db.collection("users").addDocument(data: [
                "username": nameField.text ?? "",
                "password": passwordField.text ?? "",
                "id": generateUserRandId
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        UserMessage.shared.loggedInUser = User(id: generateUserRandId, username: nameField.text ?? "")
                        self.presentChatView()
                    }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        settings.areTimestampsInSnapshotsEnabled = true
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        db.settings = settings
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        print(actionType)
        print("test")
        super.viewDidLayoutSubviews()
        self.usernameText.setPlaceHolderColor(placeholderText: "User name")
        self.passwordText.setPlaceHolderColor(placeholderText: "Password")
        self.passwordView.layer.cornerRadius = 8
        self.usernameView.layer.cornerRadius = 8
        self.signupBtn.layer.cornerRadius = 8
        self.headerView.logoutView.isHidden = true
        
        if actionType == homeAction.login.rawValue {
            signupBtn.setTitle("Login", for: .normal)
        } else {
            signupBtn.setTitle("Sign up", for: .normal)
        }
    }
    
    func presentChatView() {
        let sb = UIStoryboard.init(name: "Chat", bundle: nil)
        let modal = sb.instantiateViewController(withIdentifier: "chatStoryboard") as! ChatViewController
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.present(modal, animated: true, completion: nil)
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

extension UITextField{
    func setPlaceHolderColor(placeholderText: String){
       self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}


