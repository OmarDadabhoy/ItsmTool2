//
//  UserInfoViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/2/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {

    var email: String = ""
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    let db = Firestore.firestore()
    @IBOutlet weak var makeUserAdminButton: UIButton!
    @IBOutlet weak var removeUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(!isAdmin){
            self.makeUserAdminButton.isHidden = true
            self.removeUserButton.isHidden = true
        }
        emailField.text! = email
        emailField.isUserInteractionEnabled = false
        getUserData()
    }
    
    func getUserData() {
        let docRef = db.collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                for docData in data! {
                    if(docData.key == "Full Name"){
                        self.nameField.text! = docData.value as! String
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //Make the selected user an admin
    @IBAction func makeUserAdmin(_ sender: Any) {
        //Just override the users current data keeping his emai land stuff the same just make him an admin
        self.db.collection("Access Codes").document(currentAccessCode).updateData([self.email: ["Admin", self.nameField.text!]])
    }
    
    //remove the user
    @IBAction func removeUser(_ sender: Any) {
        //Ask the user if they want to remove the user
        let alertController = UIAlertController(title: "Are you sure you want to remove this user?", message: "This is undoable and the user must rejoin the server if he or she needs to get back in", preferredStyle: .alert)
        //if they do go ahead and contine
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction!) in
            self.db.collection("users").document(self.email).updateData([
                currentAccessCode: FieldValue.delete()
            ]) { err in
                if let err = err{
                    print("cant delete")
                } else {
                    print("success")
                }
            }
            self.db.collection("Access Codes").document(currentAccessCode).updateData([
                self.email: FieldValue.delete()
            ]){ err in
                if let err = err {
                    print("cant delete")
                }
            }
        }
        //if not just cancel
        let alertAction2 = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        alertController.addAction(alertAction2)
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
