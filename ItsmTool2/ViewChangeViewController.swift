//
//  ViewChangeViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/24/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class ViewChangeViewController: UIViewController {

    var changeName: String = ""
    @IBOutlet weak var changeTypeField: UITextField!
    @IBOutlet weak var changeNameField: UITextField!
    @IBOutlet weak var changeStartDate: UITextField!
    @IBOutlet weak var changeEndDate: UITextField!
    @IBOutlet weak var changeCategory: UITextField!
    @IBOutlet weak var changePriorityField: UITextField!
    @IBOutlet weak var changeEstimatedrisk: UITextField!
    @IBOutlet weak var changeEstimatedImpact: UITextField!
    @IBOutlet weak var changeShortDescription: UITextField!
    @IBOutlet weak var changeFullDescription: UITextView!
    @IBOutlet weak var deleteChange: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.changeFullDescription.layer.borderWidth = 2.0
        self.changeFullDescription.layer.borderColor = UIColor.gray.cgColor
        self.changeNameField.text = changeName
        self.changeNameField.isUserInteractionEnabled = false
        if(!isAdmin){
            deleteChange.isHidden = true
        }
        getData() { (data) in
            //set text up
            self.changeTypeField.text = data[3]
            self.changeStartDate.text = data[1]
            self.changeEndDate.text = data[2]
            self.changeCategory.text = data[4]
            self.changePriorityField.text = data[5]
            self.changeEstimatedrisk.text = data[6]
            self.changeEstimatedImpact.text = data[7]
            self.changeShortDescription.text = data[8]
            self.changeFullDescription.text = data[9]
            
            self.changeTypeField.isUserInteractionEnabled = false
            self.changeStartDate.isUserInteractionEnabled = false
            self.changeEndDate.isUserInteractionEnabled = false
            self.changeCategory.isUserInteractionEnabled = false
            self.changePriorityField.isUserInteractionEnabled = false
            self.changeEstimatedrisk.isUserInteractionEnabled = false
            self.changeEstimatedImpact.isUserInteractionEnabled = false
            self.changeShortDescription.isUserInteractionEnabled = false
            self.changeFullDescription.isEditable = false
        }
    }
    
    //returns the data of the current change
    private func getData(completionHandler: @escaping ([String]) -> ()) {
        let docRef = db.collection("Access Code Changes").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                for docData in data! {
                    if(docData.key == self.changeName){
                        completionHandler(docData.value as! [String])
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    

    //deletes the change off the server
    //only the admin can do this
    @IBAction func deleteChange(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to delete this change?", message: "Deleting the change means you or no one else in the channel will have access to it (This cannot be undone)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Continue", style: .default) { (action:UIAlertAction!) in
            //if they still want to close go ahead and delete the info of of the database and update the table controller
            db.collection("Access Code Changes").document(currentAccessCode).updateData([self.changeNameField.text!: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating doc")
                } else{
                    print("Doc updated")
                    if let navController = self.navigationController{
                        navController.popViewController(animated: true)
                    }
                }
            }
        })
        self.present(alertController, animated: true, completion: nil)
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
