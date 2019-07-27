//
//  EmployeeDesignationEmployerViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/26/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class EmployeeDesignationEmployerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = []
    var pickedData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("at designation")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        self.fillTableData()
    }
    
    //fills the table with all the users
    func fillTableData() {
        let docRef = db.collection("Access Codes").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                print("xxxxxxxx")
                let data = document.data()
                for docData in data! {
                    if(docData.key != "company name"){
                        self.tableData.append(docData.key)
                    }
                }
                print(self.tableData)
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //The number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    //The current cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")
        let text = tableData[indexPath.row]
        cell?.textLabel?.text = text
        return cell!
    }
    
    //performs the segue to show the data for the incident the user clicks on
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pickedData = tableData[indexPath.row]
        self.performSegue(withIdentifier: "assignUser", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "assignUser" {
            let vc = segue.destination as? UserJobFillViewController
            vc?.userEmail = pickedData
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
