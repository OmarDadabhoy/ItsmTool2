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

class SignupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

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
    @IBOutlet weak var companyOrChannelNameLabel: UILabel!
    let toolBar = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.employerOrEmployee.delegate = self
        //make sure the field can only get data from the picker
        self.employerOrEmployeeField.inputView = employerOrEmployee
        //set the fields original text to the "Employer"
        self.employerOrEmployeeField.text = pickerData[0]
        self.accessCodeLabel.isHidden = true
        email.delegate = self
        password.delegate = self
        retypePassword.delegate = self
        employerOrEmployeeField.delegate = self
        accessCodeorCompanyNameField.delegate = self
        fullNameField.delegate = self
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.employerOrEmployeeField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker(){
        self.employerOrEmployeeField.resignFirstResponder()
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
                let docRef = self.db.collection("Access Codes").document(accessCode)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!){ (user, error) in
                            if error == nil{
                                //add the current user as an employee
                                self.db.collection("Access Codes").document(accessCode).updateData([self.email.text!: ["Employee", self.fullNameField.text!]])
                                //Add the user to the user database and the Auth should make sure this user is not previously registered
                                self.db.collection("users").document(self.email.text!).setData(["Full Name": self.fullNameField.text!, accessCode: "access code"])
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
                    } else {
                        print("Document does not exist")
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
                        self.accessCodeExists(){ (accessCode) in
//                         Adds the access Code to the the document and sets it data
                            self.db.collection("Access Codes").document(accessCode).setData(["company name": self.accessCodeorCompanyNameField.text!, self.email.text!: ["Admin", self.fullNameField.text!]])
                           //add the user to the users
                           self.db.collection("users").document(self.email.text!).setData(["Full Name": self.fullNameField.text!, accessCode: "access code"])
                            //let the user know that their stuff has been completed and give them their accessCode
                            let alertController = UIAlertController(title: "Your access code is " + accessCode, message: "Give those access codes to your employees or whoever you want to add to the server so they can join your server", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: .cancel
                                , handler: nil)
                            alertController.addAction(defaultAction)
                            //perform the segue to the home screen
                            self.performSegue(withIdentifier: "signupToHome", sender: self)
                            self.present(alertController, animated: true, completion: nil)
                        }
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
    
    //Generates an access code and Checks to see if the Access Code is in the database already
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
    static func randomString(length: Int) -> String {
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
            self.companyOrChannelNameLabel.isHidden = false
        }
    }
    
    //if the user selects employee then do this
    func ifEmployee(){
        //reveal these fields so the employee can input his or her access code given by the employer
        self.accessCodeLabel.isHidden = false
        self.companyOrChannelNameLabel.isHidden = true
    }
    
    //sends the email to the home view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeViewController {
            let vc = segue.destination as? HomeViewController
            vc?.email = self.email.text!
        }
    }
    
    //disables the keyboard after hitting return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //sees where the user touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: employerOrEmployee)
            print(position)
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
