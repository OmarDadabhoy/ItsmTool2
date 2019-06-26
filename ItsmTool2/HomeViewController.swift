//
//  HomeViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/25/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var email: String = ""
    let db = Firestore.firestore()
    var fullName: String = ""
    var pickerData: [String] = []
    @IBOutlet weak var groupPickerField: UITextField!
    var groupPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.groupPicker.delegate = self
        self.groupPickerField.inputView = groupPicker
        fillPickerData()
    }
    
    //Fills the picker data with all the access codes the user is affiliated with 
    func fillPickerData(){
        let docRef = db.collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                for doc in documentData!{
                    //add all the accessCodes to the picker
                    if(doc.key != "Full Name"){
                        print("entering for loop " + (doc.key))
                        self.pickerData.append((doc.key))
                        //set the name here
                    } else {
                        self.fullName = doc.value as! String
                    }
                }
                print(self.pickerData)
                if(self.pickerData.count >= 1){
                    self.groupPickerField.text = self.pickerData[0]
                } else {
                    self.groupPickerField.text = "You are not currently in any channels please join a channel"
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //logs the user out of the app
    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError{
            print("Error signing out: %@", signOutError)
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyBoard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    //adds a new channel for the user
    @IBAction func joinNewChannel(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter Access Code", message: nil, preferredStyle: .alert)
        alertController.addTextField() { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the access code of the channel you want to join"
        }
        let saveAction = UIAlertAction(title: "Join", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            let docRef = self.db.collection("Access Codes").document(textField.text!)
            docRef.getDocument(){ (document, error) in
                if let document = document, document.exists {
                    self.db.collection("Access Codes").document(textField.text!).updateData([self.email: ["Employee", self.fullName]])
                    //Add the user to the user database and the Auth should make sure this user is not previously registered
                    self.db.collection("users").document(self.email).setData([textField.text! : "access code"])
                    self.pickerData.append(textField.text!)
                } else {
                    print("Document does not exist")
                    //alert the user that there is an error in their access code and it does not exist in the database
                    let alertController = UIAlertController(title: "Error", message: "The access code is not registered with us please type a valid access code", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //The current item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //sends the email to the home view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChannelViewController {
            let vc = segue.destination as? ChannelViewController
            vc?.accessCode = self.groupPickerField.text!
        }
    }
    
    @IBAction func proceedToChannel(_ sender: Any) {
        self.performSegue(withIdentifier: "goToChannel", sender: self)
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
