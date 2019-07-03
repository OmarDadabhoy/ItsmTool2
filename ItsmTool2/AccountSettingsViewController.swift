//
//  AccountSettingsViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/2/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController {

    var email: String = ""
    var fullName: String = ""
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailField.text = email
        self.emailField.isUserInteractionEnabled = false
        self.fullNameField.text = fullName
        self.fullNameField.isUserInteractionEnabled = false
    }
    
    //Sends an email to the user to allow them to change their password
    @IBAction func changePassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: email){ error in
            let alertController = UIAlertController(title: "Email Sent", message: "Check your email for details on how to change your password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
