//
//  ChannelSettingsViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/3/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class ChannelSettingsViewController: UIViewController, UITextFieldDelegate {

    var channelName: String = ""
    @IBOutlet weak var accessCodeField: UITextField!
    @IBOutlet weak var channelNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        accessCodeField.text = currentAccessCode
        accessCodeField.isUserInteractionEnabled = false
        getChannelName()
        channelNameField.delegate = self
    }
    
    //returns the string channel name of the access code
    func getChannelName() {
        let docRef = db.collection("Access Codes").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                for docData in data! {
                    if(docData.key == "company name") {
                        self.channelName = docData.value as! String
                    }
                }
                self.channelNameField.text = self.channelName
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //request a new access code
    @IBAction func requestNewAccesscode(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to reset your access code?", message: nil, preferredStyle: .alert)
        //create the new access code
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
            //get a new access code
            self.accessCodeExists(){ (accessCode) in
                //find the current access code
                db.collection("Access Codes").document(currentAccessCode).getDocument{ (document, error) in
                    if let document = document, document.exists{
                        //transfer the data over to the new access code
                        let data = document.data()
                        db.collection("Access Codes").document(accessCode).setData(data!)
                        self.accessCodeField.text = accessCode
                        //loop through and find each user delete the access code of each user
                        for docData in data! {
                            if(docData.key != "company name"){
                                //delete the old access code
                                db.collection("users").document(docData.key).updateData([currentAccessCode: FieldValue.delete()
                                ]){ err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                                //add the new one
                                db.collection("users").document(docData.key).updateData([accessCode: "access code"])
                            }
                        }
                        //delete the old access code and set the currentAccessCode to the new access code
                        db.collection("Access Codes").document(currentAccessCode).delete() { err in
                            if let err = err{
                                print("error in deleting document")
                            } else{
                                print("deleted")
                                currentAccessCode = accessCode
                            }
                        }
                        //alert the user
                        let alertController2 = UIAlertController(title: "Success", message: "Your new access code is " + accessCode, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController2.addAction(alertAction)
                        self.present(alertController2, animated: true, completion: nil)
                    } else {
                        print("Does not exist")
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //saves any changes the user made
    @IBAction func saveData(_ sender: Any) {
        
    }
    
    //Checks to see if the access code already in the database
    private func accessCodeExists(completionHandler: @escaping (String) -> ()) {
        let accessCode = SignupViewController.randomString(length: 6)
        let docRef = db.collection("Access Codes").document(accessCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.accessCodeExists() { (newAccessCode) in
                    completionHandler(newAccessCode)
                }
            } else {
                print("Document does not exist")
                completionHandler(accessCode)
            }
        }
    }
    
    //disables the keyboard after hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
