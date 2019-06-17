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

    @IBOutlet weak var groupPicker: UIPickerView!
    var pickerData: [String] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.groupPicker.delegate = self
        
    }
    
    //This method fills the picker view with all the channels they are involved in
    func fillPickerData(){
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
