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
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil {
                    //if the person is an employer
                    if(self.isEmployer()){
                        //randomly generate an accessCode for them
                        var accessCode = self.randomString(length: 6)
                        //create a reference to the database
                        let ref = Database.database().reference()
//                        var existsInDatabase: Bool = true
//                        //run as long as the accessCode exists in the database
//                        while(existsInDatabase){
//                            //if the snapshot exists then re create the accessCode and try again
//                            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                                if snapshot.hasChild(accessCode) {
//                                    accessCode = self.randomString(length: 6)
//                                } else {
//                                    existsInDatabase = false
//                                }
//                            })
//                        }
                        //Builds a child access code and another child containing the first users info
//                        ref.child(accessCode).child(self.email.text!).setValue(["name": self.fullNameField.text!, "Role": "Admin"])
                        let alertController = UIAlertController(title: "Your access code is " + accessCode, message: "Give those access codes to your employees or whoever you want to add to the server so they can join your server", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel
                            , handler: nil)
                        alertController.addAction(defaultAction)
                        self.performSegue(withIdentifier: "signupToHome", sender: self)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        //create a reference
                        let ref = Database.database().reference()
                        //get the accessCode that the employee typed in
                        let accessCode = self.accessCodeorCompanyNameField.text!
                        //if the accessCode is registered in the database then the user is good else let them know it doesnt
                        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.hasChild(accessCode){
                                //TODO
                                //possibly could be flawed but should account to the list
                                ref.child(accessCode).child(self.email.text!).setValue(["name": self.fullNameField.text!, "Role": "Employee"])
                                self.performSegue(withIdentifier: "signupToHome", sender: self)
                            } else{
                                //alert the user that there is an error in their access code and it does not exist
                                let alertController = UIAlertController(title: "Error", message: "The access code is not registered with us please type a valid access code", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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
