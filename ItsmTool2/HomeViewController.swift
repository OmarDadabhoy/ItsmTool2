//
//  HomeViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/7/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var pickerData: [String] = []
    let db = Firestore.firestore()
    var email: String = ""
    var groupPicker2 = UIPickerView()
    @IBOutlet weak var groupField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.groupPicker2.delegate = self
        self.groupField.inputView = groupPicker2
        if(email == ""){
            if let x = UserDefaults.standard.object(forKey: "userEmail") as? String {
                email = x
            }
        } else {
            UserDefaults.standard.set(email, forKey: "userEmail")
        }
        print(email)
        self.fillPickerData()
    }
    
    //This method fills the picker view with all the channels they are involved in
    func fillPickerData(){
        let docRef = db.collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                for doc in documentData!{
                    print("entering for loop " + (doc.value as! String))
                    self.pickerData.append((doc.value as! String))
                }
                print(self.pickerData)
                if(self.pickerData.count >= 1){
                    self.groupField.text = self.pickerData[0]
                } else {
                    self.groupField.text = "You are not currently in any channels please join a channel"
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //This method sets up the logout button and what itll do when clicker
    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError{
            print("Error signing out: %@", signOutError)
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyBoard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
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
    
    //This method is connected to the enter channel button which will allow the user to enter
    @IBAction func enterChannel(_ sender: Any) {
        self.performSegue(withIdentifier: "proceedToChannel", sender: self)
    }
    
    //This method allows the user to add another access code and enter a new channel
    @IBAction func joinNewChannel(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter Access Code", message: nil, preferredStyle: .alert)
        alertController.addTextField() { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the access code of the channel you want to join"
        }
        let saveAction = UIAlertAction(title: "Join", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
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
