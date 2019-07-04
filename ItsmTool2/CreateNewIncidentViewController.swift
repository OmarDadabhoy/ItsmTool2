//
//  CreateNewIncidentViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/26/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateNewIncidentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var creatorTextField: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var urgencyTextField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    var urgencyPicker = UIPickerView()
    let pickerData: [String] = ["1 - Most Urgent", "2", "3", "4", "5 - Least Urgent"]
    let db = Firestore.firestore()
    var callbackResult: ((String) -> ())?
    var callBackResultStringArray: (([String]) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        urgencyPicker.delegate = self
        urgencyTextField.inputView = urgencyPicker
        urgencyTextField.text = pickerData[0]
        creatorTextField.text = userFullName
        creatorTextField.isUserInteractionEnabled = false
        let todayDate = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: todayDate)
        print(formattedDate)
        date.text = formattedDate
        date.isUserInteractionEnabled = false
        print(nameTextField.text! + "test")
    }
    
    //Cancels and goes back to the incidents
    @IBAction func cancel(_ sender: Any) {
        if let navController = self.navigationController{
            navController.popViewController(animated: true)
        }
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
    
    //contains what is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        urgencyTextField.text = pickerData[row]
    }
    
    //cretes a new incident
    @IBAction func createIncident(_ sender: Any) {
        if(self.nameTextField.text! != "") {
            let docRef = db.collection("Access Code Incidents").document(currentAccessCode)
            docRef.getDocument { (document, error) in
                //if the document exists
                if let document = document, document.exists {
                    let data = document.data()
                    var found: Bool = false
                    //Check to see if the name is not in there
                    for name in data! {
                        if(name.key == self.nameTextField.text!) {
                            found = true
                        }
                    }
                    //if its found let the user know they need to pick another one
                    if(found){
                        let alertController = UIAlertController(title: "The name has already been used", message: "The name you have chosen for this incident is already in use please try another one", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        //if it was not found then go ahead and add the data
                        self.db.collection("Access Code Incidents").document(currentAccessCode).updateData([self.nameTextField.text!: [self.creatorTextField.text!, self.date.text!, self.urgencyTextField.text!, self.descriptionField.text!, userEmail]])
                        //update everything in the incidents table
                        if let navController = self.navigationController{
                            self.callbackResult?(self.nameTextField.text!)
                            self.callBackResultStringArray?([self.creatorTextField.text!, self.date.text!, self.urgencyTextField.text!, self.descriptionField.text!, userEmail])
                            navController.popViewController(animated: true)
                        }
                    }
                    //if the document is not in there then just make it
                } else {
                    print("Document does not exist")
                    self.db.collection("Access Code Incidents").document(currentAccessCode).setData([self.nameTextField.text!: [self.creatorTextField.text!, self.date.text!, self.urgencyTextField.text!, self.descriptionField.text!, userEmail]])
                    //Send the incident name back
                    if let navController = self.navigationController{
                        self.callbackResult?(self.nameTextField.text!)
                        navController.popViewController(animated: true)
                    }
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
