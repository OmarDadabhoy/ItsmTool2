//
//  UserJobFillViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/27/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class UserJobFillViewController: UIViewController {

    @IBOutlet weak var shortDescription: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    var userEmailHere: String = ""
    @IBOutlet weak var DueDate: UITextField!
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.descriptionField.layer.borderWidth = 2.0
        self.descriptionField.layer.borderColor = UIColor.gray.cgColor
        
        //due date
        DueDate.inputView = datePicker
        DueDate.inputAccessoryView = toolBar
        
        //date stuff
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        //tool bar
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    //exits out of the picker
    @objc func donePicker(){
        DueDate.resignFirstResponder()
    }
    
    //handles changing the date
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        DueDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    //sumbits the role/todo to the server
    @IBAction func submit(_ sender: Any) {
        let docRef = db.collection("Employee Designation").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            //if the document exists
            if let document = document, document.exists {
                let data = document.data()
                var key: String = SignupViewController.randomString(length: 6)
                
                db.collection("Employee Designation").document(currentAccessCode).setData([self.userEmailHere: [key : [self.shortDescription.text!, self.descriptionField.text!, self.DueDate.text!, userEmail]]], merge: true)
                db.collection("Employee Designation").document(currentAccessCode).setData([userEmail: [key : [self.shortDescription.text!, self.descriptionField.text!, self.DueDate.text!, self.userEmailHere]]], merge: true)
                if let navController = self.navigationController{
                    navController.popViewController(animated: true)
                }
            } else {
                var key: String = SignupViewController.randomString(length: 6)
                db.collection("Employee Designation").document(currentAccessCode).setData([self.userEmailHere: [key : [self.shortDescription.text!, self.descriptionField.text!, self.DueDate.text!, userEmail]]], merge: true)
                db.collection("Employee Designation").document(currentAccessCode).setData([userEmail: [key : [self.shortDescription.text!, self.descriptionField.text!, self.DueDate.text!, self.userEmailHere]]], merge: true)
                if let navController = self.navigationController{
                    navController.popViewController(animated: true)
                }
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
