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
    var toolBar = UIToolbar()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //set up the activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.groupPicker.delegate = self
        self.groupPickerField.inputView = groupPicker
        fillPickerData()
        
        //set up the toolbar
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.groupPickerField.inputAccessoryView = toolBar
    }
    
    //resign the picker
    @objc func donePicker(){
        self.groupPickerField.resignFirstResponder()
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
                        self.navigationItem.title = self.fullName
                    }
                }
                print(self.pickerData)
                if(self.pickerData.count >= 1){
                    self.groupPickerField.text = self.pickerData[0]
                } else {
                    self.groupPickerField.text = "You are not currently in any channels please join a channel"
                }
                //end the activity loader
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
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
//                    self.db.collection("Access Codes").document(textField.text!).getDocument(){ (document, error) in
//                        if let document = document, document.exists {
//                            var data = document.data()
//                            data![self.email] = ["Employee", self.fullName]
//                            self.db.collection("Access Codes").document(textField.text!).setData(data!)
//                        }
//                    }
                    self.db.collection("Access Codes").document(textField.text!).setData([self.email: ["Employee", self.fullName]], merge: true)
                    //Add the user to the user database and the Auth should make sure this user is not previously registered
                    self.db.collection("users").document(self.email).updateData([textField.text! : "access code"])
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
        if segue.destination is AccountSettingsViewController {
            let vc = segue.destination as? AccountSettingsViewController
            vc?.email = self.email
            vc?.fullName = self.fullName
        }
    }
    
    //contains what is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        groupPickerField.text = pickerData[row]
    }
    
    //proceed to the channel
    @IBAction func proceedToChannel(_ sender: Any) {
        currentAccessCode = groupPickerField.text!
        userEmail = self.email
        userFullName = self.fullName
        let docRef = db.collection("Access Codes").document(currentAccessCode)
        //figures out if the user is an admin of the server or not
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                //go through the access codes users
                for docData in data! {
                    //once we find the userEmail then check if its an admin, if not then keep it
                    if(docData.key == userEmail) {
                        let fields = docData.value as! [String]
                        if(fields[0] == "Admin"){
                            isAdmin = true
                        } else {
                            isAdmin = false
                        }
                    }
                }
            }
        }
        self.performSegue(withIdentifier: "goToChannel", sender: self)
    }
    
    //gets the user to account settings
    @IBAction func goToAccountSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAccountSettings", sender: self)
    }
    
    //Allows the user to create a new channel and be the admin of it with a new access code
    @IBAction func createNewChannel(_ sender: Any) {
        let alertController = UIAlertController(title: "What is the channel/company Name?", message: nil, preferredStyle: .alert)
        alertController.addTextField() { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the name of the channel"
        }
        let saveAction = UIAlertAction(title: "Create Channel", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            self.accessCodeExists() { (accessCode) in
                //Adds the access Code to the the document and sets it data
                self.db.collection("Access Codes").document(accessCode).setData(["company name": textField.text!, self.email: ["Admin", self.fullName]])
                //add the user to the users
                self.db.collection("users").document(self.email).updateData([accessCode: "access code"])
                self.pickerData.append(accessCode)
                //let the user know that their stuff has been completed and give them their accessCode
                let alertController2 = UIAlertController(title: "Your access code is " + accessCode, message: "Give those access codes to your employees or whoever you want to add to the server so they can join your server", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel
                    , handler: nil)
                alertController2.addAction(defaultAction)
                self.present(alertController2, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Checks to see if the access code already in the database
    private func accessCodeExists(completionHandler: @escaping (String) -> ()) {
        let accessCode = SignupViewController.randomString(length: 6)
        let docRef = self.db.collection("Access Codes").document(accessCode)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
