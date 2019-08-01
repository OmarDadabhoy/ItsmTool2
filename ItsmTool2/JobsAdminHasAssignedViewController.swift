//
//  JobsAdminHasAssignedViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/31/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class JobsAdminHasAssignedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = []
    var tableDataInfo: [[String]] = []
    var pickedIndex: Int = 0
    var tableKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        fillTableData()
    }
    
    //fills the table data
    func fillTableData(){
        db.collection("Employee Designation").document(currentAccessCode).getDocument(){ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var found: Bool = false
                var result: [String:[String]] = [:]
                for docData in data! {
                    if(docData.key == userEmail){
                        found = true
                        result = docData.value as! [String: [String]]
                    }
                }
                if(!found){
                    let alertController = UIAlertController(title: "You have not assigned any jobs", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    for val in result{
                        self.tableData.append(val.value[0])
                        self.tableKeys.append(val.key)
                        self.tableDataInfo.append(val.value)
                    }
                    if(self.tableData.isEmpty){
                        let alertController = UIAlertController(title: "You have not assigned any jobs", message: nil, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.tableView.reloadData()
                    }
                }
            } else {
                let alertController = UIAlertController(title: "You have not assigned any jobs", message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
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
        pickedIndex = indexPath.row
        self.performSegue(withIdentifier: "viewJobYouHaveAskedFor", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewJobAdminViewController {
            let vc = segue.destination as? ViewJobAdminViewController
            vc?.currentInfo = tableDataInfo[pickedIndex]
            vc?.currentKey = tableKeys[pickedIndex]
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
