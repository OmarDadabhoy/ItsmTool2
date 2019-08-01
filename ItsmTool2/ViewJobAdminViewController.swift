//
//  ViewJobAdminViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 8/1/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class ViewJobAdminViewController: UIViewController {

    var currentKey: String = ""
    var currentInfo: [String] = []
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var assignedPerson: UITextField!
    @IBOutlet weak var shortDescription: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.descriptionField.layer.borderWidth = 2.0
        self.descriptionField.layer.borderColor = UIColor.gray.cgColor
        
        dueDate.text = currentInfo[2]
        assignedPerson.text = currentInfo[3]
        shortDescription.text = currentInfo[0]
        descriptionField.text = currentInfo[1]
    }
    
    //updates the data
    @IBAction func updateData(_ sender: Any) {
        db.collection("Employee Designation").document(currentAccessCode).setData([self.assignedPerson.text!: [currentKey : [self.shortDescription.text!, self.descriptionField.text!, self.dueDate.text!, userEmail]]], merge: true)
    }
    
    //withdraws the job and removes it from the database
    @IBAction func withdrawJob(_ sender: Any) {
        let alertcontroller = UIAlertController(title: "Are you sure you want to withdraw this job?", message: "This will permanently remove the the job", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let alertAction2 = UIAlertAction(title: "Ok", style: .default, handler: { alert -> Void in
            db.collection("Employee Designation").document(currentAccessCode).updateData([
                self.currentKey: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        })
        alertcontroller.addAction(alertAction)
        alertcontroller.addAction(alertAction2)
        self.present(alertcontroller, animated: true, completion: nil)
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
