//
//  ViewJobViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/30/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class ViewJobViewController: UIViewController {

    var currentDocData: [String] = []
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var asker: UITextField!
    @IBOutlet weak var shortDescription: UITextField!
    @IBOutlet weak var fullDescription: UITextView!
    var currentDocKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //text view work
        self.fullDescription.layer.borderWidth = 2.0
        self.fullDescription.layer.borderColor = UIColor.gray.cgColor
        
        //fill text fields with info
        dueDate.text = currentDocData[2]
        asker.text = currentDocData[3]
        shortDescription.text = currentDocData[0]
        fullDescription.text = currentDocData[1]
        fullDescription.isEditable = false
        dueDate.isUserInteractionEnabled = false
        asker.isUserInteractionEnabled = false
        shortDescription.isUserInteractionEnabled = false
        
    }
    
    //user can click this if they are done with the job
    @IBAction func doneWithJob(_ sender: Any) {
        db.collection("Employee Designation").document(currentAccessCode).setData([userEmail: [currentDocKey : [self.shortDescription.text!, self.fullDescription.text!, self.dueDate.text!, userEmail, "done"]]], merge: true)
    }
    
    //lets the user ask for more time
    @IBAction func askForMoreTime(_ sender: Any) {
        
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
