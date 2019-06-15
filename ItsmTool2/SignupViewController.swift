//
//  SignupViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/7/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    var employerOrEmployee = UIPickerView()
    let pickerData: [String] = [String](arrayLiteral: "Employer", "Employee")
    @IBOutlet weak var employerOrEmployeeField: UITextField!
    @IBOutlet weak var accessCodeLabel: UILabel!
    @IBOutlet weak var accessCodeorCompanyNameField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.employerOrEmployee.delegate = self
        //make sure the field can only get data from the picker
        self.employerOrEmployeeField.inputView = employerOrEmployee
        //set the fields original text to the "Employer"
        self.employerOrEmployeeField.text = pickerData[0]
        self.accessCodeLabel.isHidden = true
        self.accessCodeorCompanyNameField.isHidden = true
    }
    
    //Signs the user up for the application
    @IBAction func signup(_ sender: Any) {
        if password.text != retypePassword.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            //if an employee is signing up do this
            if(!self.isEmployer()){
                //get the accessCode that the employee typed in
                let accessCode = self.accessCodeorCompanyNameField.text!
                var found: Bool = false
                self.db.collection("Access Codes").getDocuments() { (QuerySnapshot, err) in
                    //error message
                    if let err = err{
                        print("Error getting documents: \(err)")
                        //loop through the documents and check if it exists which set exists to true or false based of that
                    } else {
                        //loop through the documents
                        for document in QuerySnapshot!.documents {
                            //if one exists make sure we keep set exists to true
                            if(document.documentID == accessCode){
                                found = true
                                //create a user
                                Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!){ (user, error) in
                                    if error == nil{
                                        //create a reference to the Access Codes collection and the accessCode within
                                        let accessCodeRef = self.db.collection("Access Codes").document(accessCode)
                                        //add the current user as an employee
                                        accessCodeRef.updateData([self.email.text! : ["Employee", self.fullNameField.text!]])
                                        //Add the user to the user database and the Auth should make sure this user is not previously registered
                                        self.db.collection("users").document(self.email.text!).setData(["access code" : accessCode])
                                        //take them to home
                                        self.performSegue(withIdentifier: "signupToHome", sender: self)
                                        
                                    } else {
                                        //present error statements when failing to create user
                                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        
                                        alertController.addAction(defaultAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                    //if the accessCode is registered in the database then the user is good else let them know it doesnt
                    if(!found){
                        //alert the user that there is an error in their access code and it does not exist in the database
                        let alertController = UIAlertController(title: "Error", message: "The access code is not registered with us please type a valid access code", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
                //enter this if the person is an employer
            } else {
                Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                    if error == nil {
                        //randomly generate an accessCode for them
                        var accessCode = self.randomString(length: 6)
                        var alreadyThere: Bool = true
                        //as long as the accessCode is in the database keep generating new ones
                        while(alreadyThere) {
                            self.db.collection("Access Codes").getDocuments() { (QuerySnapshot, err) in
                                //error message
                                if let err = err{
                                    print("Error getting documents: \(err)")
                                    //loop through the documents and check if it exists which set exists to true or false based of that
                                } else {
                                    var exists : Bool = false
                                    //loop through the documents
                                    for document in QuerySnapshot!.documents {
                                        //if one exists make sure we keep set exists to true
                                        if(document.documentID == accessCode){
                                            exists = true
                                        }
                                    }
                                    if(exists){
                                        accessCode = self.randomString(length: 6)
                                    } else {
                                        alreadyThere = false
                                    }
                                }
                            }
                        }
                        //Adds the access Code to the the document and sets it data
                        self.db.collection("Access Codes").document(accessCode).setData([self.email.text!: ["Admin", self.fullNameField.text!]])
                        //add the user to the users 
                        self.db.collection("users").document(self.email.text!).setData(["access code" : accessCode])
                        //let the user know that their stuff has been completed and give them their accessCode
                        let alertController = UIAlertController(title: "Your access code is " + accessCode, message: "Give those access codes to your employees or whoever you want to add to the server so they can join your server", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel
                                , handler: nil)
                        alertController.addAction(defaultAction)
                        //perform the segue to the home screen
                        self.performSegue(withIdentifier: "signupToHome", sender: self)
                        self.present(alertController, animated: true, completion: nil)
                    } else{
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //Checks to see if the access code has already been put into the database
    private func isAccessCodeAlreadyInDatabase(accessCode: String) -> Bool {
        //create the exists variable and set it to false
        var exists: Bool = false
        //go through the access codes collection and get all the documents
        self.db.collection("Access Codes").getDocuments() { (QuerySnapshot, err) in
            //error message
            if let err = err{
                print("Error getting documents: \(err)")
                //loop through the documents and check if it exists which set exists to true or false based of that
            } else {
                //loop through the documents
                for document in QuerySnapshot!.documents {
                    //if one exists make sure we keep set exists to true
                    if(document.documentID == accessCode){
                        exists = true
                    }
                }
            }
        }
        //return exists
        return exists
    }
    
    //This function determines if the signer up is an employer or not
    private func isEmployer() -> Bool {
        //if the accessCodeLabel is hidden the user selected employer
        if self.accessCodeLabel.isHidden{
            return true
            //else they selected employee
        } else{
            return false
        }
    }
    
    //This function randomly generates a string of a length in order to create the access code for the user
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //number of column components in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //The current item
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //contains what is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        employerOrEmployeeField.text = pickerData[row]
        if(row == 1){
            ifEmployee()
        } else{
            self.accessCodeLabel.isHidden = true
            self.accessCodeorCompanyNameField.isHidden = true
        }
    }
    
    //if the user selects employee then do this
    func ifEmployee(){
        //reveal these fields so the employee can input his or her access code given by the employer
        self.accessCodeLabel.isHidden = false
        self.accessCodeorCompanyNameField.isHidden = false
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
