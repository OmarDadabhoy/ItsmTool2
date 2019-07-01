//
//  ViewIncidentViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/27/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class ViewIncidentViewController: UIViewController {
    
    let db = Firestore.firestore()
    var incidentName: String = ""
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var creatorTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var urgencyTextField: UITextField!
    @IBOutlet weak var Descirption: UITextField!
    @IBOutlet weak var resolver: UITextField!
    @IBOutlet weak var resolveIncidentButton: UIButton!
    @IBOutlet weak var closeIncidentButton: UIButton!
    var incidentEmail: String = ""
    @IBOutlet weak var resolvedButton: UIButton!
    var callbackResult: ((String) -> ())?
    @IBOutlet weak var stopResolvingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.text = incidentName
        nameTextField.isUserInteractionEnabled = false
        self.stopResolvingButton.isHidden = true
        self.resolvedButton.isHidden = true
        self.resolveIncidentButton.isHidden = false
        getData() { (data) in
            self.creatorTextField.text = data[0]
            self.dateTextField.text = data[1]
            self.urgencyTextField.text = String(data[2].first!)
            self.Descirption.text = data[3]
            self.incidentEmail = data[4]
            if(data.count >= 6){
                self.resolver.text = data[5]
                self.resolveIncidentButton.isHidden = true
                self.stopResolvingButton.isHidden = false
                self.resolvedButton.isHidden = false
            }
            if(data.count == 7){
                self.resolvedButton.isHidden = true
                self.stopResolvingButton.isHidden = true
            }
            self.creatorTextField.isUserInteractionEnabled = false
            self.dateTextField.isUserInteractionEnabled = false
            self.urgencyTextField.isUserInteractionEnabled = false
            self.Descirption.isUserInteractionEnabled = false
            if(userEmail != self.incidentEmail && !isAdmin){
                self.closeIncidentButton.isHidden = true
            }
        }
    }
    
    //Gets the information for the incident
    func getData(completionHandler: @escaping ([String]) -> ()) {
        let docRef = db.collection("Access Code Incidents").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                for docData in data! {
                    if(docData.key == self.incidentName){
                        completionHandler(docData.value as! [String])
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //Lets the user say they are resolving the incident
    @IBAction func resolveIncident(_ sender: Any) {
        //set the resolver in firebase
        self.db.collection("Access Code Incidents").document(currentAccessCode).updateData([self.nameTextField.text!: [self.creatorTextField.text!, self.dateTextField.text!, self.urgencyTextField.text!, self.Descirption.text!, incidentEmail, userEmail]])
        //hide the button and make the Ui changes
        self.resolveIncidentButton.isHidden = true
        self.stopResolvingButton.isHidden = false
        self.resolvedButton.isHidden = false
        self.resolver.text = userEmail
        //let them know they are now the resolver of this incident
        let alertController = UIAlertController(title: "You are now the resolver of this incident", message: "You are now the resolver of this incident ", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Lets the user delete/close the incident
    @IBAction func closeIncident(_ sender: Any) {
        //Ask them to make sure they want to close it
        let alertController = UIAlertController(title: "Are you sure you want to close/delete this incident?", message: "Closing the incident means you or no one else in the channel will have access to it (This cannot be undone)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Continue", style: .default) { (action:UIAlertAction!) in
            //if they still want to close go ahead and delete the info of of the database and update the table controller
            self.db.collection("Access Code Incidents").document(currentAccessCode).updateData([self.nameTextField.text!: FieldValue.delete(),
            ]) { err in
                if let err = err{
                    print("Error updating doc")
                } else{
                    print("Doc updated")
                    if let navController = self.navigationController{
                        self.callbackResult?(self.nameTextField.text!)
                        navController.popViewController(animated: true)
                    }
                }
            }
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Resolver can click this to show that the incident has been resolved
    @IBAction func resolved(_ sender: Any) {
        self.resolvedButton.isHidden = true
        self.stopResolvingButton.isHidden = true
        self.db.collection("Access Code Incidents").document(currentAccessCode).updateData([self.nameTextField.text!: [self.creatorTextField.text!, self.dateTextField.text!, self.urgencyTextField.text!, self.Descirption.text!, incidentEmail, userEmail, "resolved"]])
    }
    
    //Lets a user drop the incident and stop resolving it
    @IBAction func stopResolvingIncident(_ sender: Any) {
        self.stopResolvingButton.isHidden = true
        self.resolvedButton.isHidden = true
        self.resolveIncidentButton.isHidden = false
        self.resolver.text = ""
        self.db.collection("Access Code Incidents").document(currentAccessCode).updateData([self.nameTextField.text!: [self.creatorTextField.text!, self.dateTextField.text!, self.urgencyTextField.text!, self.Descirption.text!, incidentEmail]])
        let alertController = UIAlertController(title: "You are no longer the resolver of this incident", message: "You are no longer the resolver of this incident ", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
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
