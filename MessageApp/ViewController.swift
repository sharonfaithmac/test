//
//  ViewController.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 9/26/18.
//  Copyright © 2018 Sharon  Macasaol. All rights reserved.
//

import UIKit

enum homeAction: Int {
    case signup = 0
    case login = 1
}

class ViewController: UIViewController {

    @IBOutlet weak var signUpBtn: UIView!
    @IBOutlet weak var loginBtn: UIView!
    
    
    @IBAction func signUp(_ sender: UIButton) {
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "signup", sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.signUpBtn.layer.cornerRadius = 10
        self.loginBtn.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let signUpViewController = segue.destination as! SignUpViewController
        signUpViewController.actionType = (sender as? UIButton)?.tag ?? 0
    }


}

