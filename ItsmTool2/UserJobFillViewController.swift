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
    var userEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.descriptionField.layer.borderWidth = 2.0
        self.descriptionField.layer.borderColor = UIColor.gray.cgColor
    }
    
    //sumbits the role/todo to the server
    @IBAction func submit(_ sender: Any) {
        let docRef = db.collection("Employee Designation").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            //if the document exists
            if let document = document, document.exists {
                db.collection("Employee Designation").document(currentAccessCode).updateData([self.userEmail: [self.shortDescription.text, self.descriptionField.text]])
            } else {
                db.collection("Employee Designation").document(currentAccessCode).setData([self.userEmail: [self.shortDescription.text, self.descriptionField.text]])
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
