//
//  CreateNewChangeViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/19/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class CreateNewChangeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var changeTypeField: UITextField!
    @IBOutlet weak var changeNameField: UITextField!
    @IBOutlet weak var changeCategory: UITextField!
    @IBOutlet weak var changePriorityField: UITextField!
    @IBOutlet weak var changeRiskField: UITextField!
    @IBOutlet weak var changeImpactField: UITextField!
    @IBOutlet weak var changeShortDescriptionField: UITextField!
    @IBOutlet weak var changeFullDescription: UITextView!
    var changeTypePicker: UIPickerView = UIPickerView()
    var changeTypeData: [String] = ["Emergency", "Regular"]
    var changePriorityPicker: UIPickerView = UIPickerView()
    var changePriorityData: [String] = ["1 - High Priority", "2", "3", "4", "5 - Low Priority"]
    var changeRiskPicker: UIPickerView = UIPickerView()
    var changeImpactPicker: UIPickerView = UIPickerView()
    var changeRiskData: [String] = ["Little to none", "Moderate risk", "High risk"]
    var changeImpactData: [String] = ["Low", "Medium", "High"]
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var fields: [UITextField] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //picker stuff
        self.changeFullDescription.layer.borderWidth = 2.0
        self.changeFullDescription.layer.borderColor = UIColor.gray.cgColor
        changeTypePicker.tag = 1
        changePriorityPicker.tag = 2
        changeRiskPicker.tag = 3
        changeImpactPicker.tag = 4
        changeTypePicker.delegate = self
        changePriorityPicker.delegate = self
        changeImpactPicker.delegate = self
        changeRiskPicker.delegate = self
        changeTypePicker.dataSource = self
        changePriorityPicker.dataSource = self
        changeRiskPicker.dataSource = self
        changeImpactPicker.dataSource = self
        
        //field stuff
        changeTypeField.inputView = changeTypePicker
        changePriorityField.inputView = changePriorityPicker
        changeRiskField.inputView = changeRiskPicker
        changeImpactField.inputView = changeImpactPicker
        dateField.inputView = startDatePicker
        endDateField.inputView = endDatePicker
        
        changeTypeField.inputAccessoryView = toolBar
        changePriorityField.inputAccessoryView = toolBar
        changeRiskField.inputAccessoryView = toolBar
        changeImpactField.inputAccessoryView = toolBar
        dateField.inputAccessoryView = toolBar
        endDateField.inputAccessoryView = toolBar
        fields = [changeTypeField, changePriorityField, changeRiskField, changeImpactField, dateField, endDateField]
        
        //date picker
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(self.endDateChanged(datePicker:)), for: .valueChanged)
        
        
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
        for field in fields {
            field.resignFirstResponder()
        }
    }
    
    
    //handles changing the end date
    @objc func endDateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        endDateField.text = dateFormatter.string(from: endDatePicker.date)
    }
    
    //handles changing the date
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        dateField.text = dateFormatter.string(from: startDatePicker.date)
    }
    
    //how many columns in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //how many rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return changeTypeData.count
        } else if(pickerView.tag == 2){
            return changePriorityData.count
        } else if(pickerView.tag == 3){
            return changeRiskData.count
        } else {
            return changeImpactData.count
        }
    }
    
    //The current item in the picker
    private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 1 {
            return changeTypeData[row]
        } else if(pickerView.tag == 2){
            return changePriorityData[row]
        } else if(pickerView.tag == 3){
            return changeRiskData[row]
        } else {
            return changeImpactData[row]
        }
    }
    
    //contains what is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            changeTypeField.text = changeTypeData[row]
        } else if(pickerView.tag == 2){
            changePriorityField.text = changePriorityData[row]
        } else if(pickerView.tag == 3){
            changeRiskField.text = changeRiskData[row]
        } else {
            changeImpactField.text = changeImpactData[row]
        }
        
    }

    //create the change
    @IBAction func createChange(_ sender: Any) {
        let docRef = db.collection("Access Code Changes").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            //if the document exists
            if let document = document, document.exists {
                let data = document.data()
                var found: Bool = false
                //check to see if the change is there or not
                for docData in data! {
                    if(docData.key == self.changeNameField.text!) {
                        found = true
                    }
                }
                //if the change has been found then let the user know they need another name
                if(found){
                    let alertController = UIAlertController(title: "The name has already been used", message: "The name you have chosen for this change is already in use please try another one", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                    //else put it in the database
                } else {
                    db.collection("Access Code Changes").document(currentAccessCode).updateData([self.changeNameField.text!: [userEmail, self.dateField.text!, self.endDateField.text!, self.changeTypeField.text!, self.changeCategory.text!, self.changePriorityField.text!, self.changeRiskField.text!, self.changeImpactField.text!, self.changeShortDescriptionField.text!, self.changeFullDescription.text!]])
                    if let navController = self.navigationController{
                        navController.popViewController(animated: true)
                    }
                }
                //if it doesnt make the document
            } else {
                db.collection("Access Code Changes").document(currentAccessCode).setData([self.changeNameField.text!: [userEmail, self.dateField.text!, self.endDateField.text!, self.changeTypeField.text!, self.changeCategory.text!, self.changePriorityField.text!, self.changeRiskField.text!, self.changeImpactField.text!, self.changeShortDescriptionField.text!, self.changeFullDescription.text!]])
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
