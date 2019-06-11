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

class SignupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    var employerOrEmployee = UIPickerView()
    let pickerData: [String] = [String](arrayLiteral: "Employer", "Employee")
    @IBOutlet weak var employerOrEmployeeField: UITextField!
    @IBOutlet weak var accessCodeLabel: UILabel!
    @IBOutlet weak var accessCodeorCompanyNameField: UITextField!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.employerOrEmployee.delegate = self
        //make sure the field can only get data from the picker
        self.employerOrEmployeeField.inputView = employerOrEmployee
        //set the fields original text to the "Employer"
        self.employerOrEmployeeField.text = pickerData[0]
        self.accessCodeLabel.isHidden = true
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
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
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
            self.companyNameLabel.isHidden = false
        }
    }
    
    //if the user selects employee then do this
    func ifEmployee(){
        //reveal these fields so the employee can input his or her access code given by the employer
        self.accessCodeLabel.isHidden = false
        self.companyNameLabel.isHidden = true
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
