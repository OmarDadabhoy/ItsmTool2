//
//  EmployeeDesignationEmployeeViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/26/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class EmployeeDesignationEmployeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        fillTableData()
    }
    
    //fills the table data
    func fillTableData(){
        let docRef = db.collection("Employee Designation").document(currentAccessCode)
        //find all the jobs for the user
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var found: Bool = false
                var result: [String] = []
                let data = document.data()
                for docData in data! {
                    if(docData.key == userEmail){
                        found = true
                        result = docData.value as! [String]
                    }
                }
                if(!found){
                    let alertController = UIAlertController(title: "You have no jobs at the moment", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                } else {
                    var i: Int = 0
                    for s in result{
                        if(i % 2 == 0){
                            self.tableData.append(s)
                        }
                        i+=1
                    }
                    self.tableView.reloadData()
                }
            } else {
                let alertController = UIAlertController(title: "You have no jobs at the moment", message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
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
