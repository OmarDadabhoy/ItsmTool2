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
    var pickedIndex: Int = 0
    var tableDataInfo: [[String]] = []
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //menu stuff
        if self.revealViewController() != nil {
            print("not nil")
            menuButton = UIBarButtonItem.init(title: "Menu", style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            //            menuButton = UIBarButtonItem.init(image: , style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            //set the leftBarButtonItem to the MenuButton
            self.revealViewController().navigationItem.leftBarButtonItem = menuButton
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
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
                var result: [String: [String]] = [:]
                let data = document.data()
                for docData in data! {
                    if(docData.key == userEmail){
                        found = true
                        result = docData.value as! [String: [String]]
                    }
                }
                if(!found){
                    let alertController = UIAlertController(title: "You have no jobs at the moment", message: nil, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                } else {
                    for val in result{
                        self.tableData.append(val.value[0])
                        self.tableDataInfo.append(val.value)
                    }
                    if(self.tableData.isEmpty){
                        let alertController = UIAlertController(title: "You have no jobs at the moment", message: nil, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true)
                    } else {
                        self.tableView.reloadData()
                    }
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
        pickedIndex = indexPath.row
        self.performSegue(withIdentifier: "viewJob", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewJobViewController {
            let vc = segue.destination as? ViewJobViewController
            vc?.currentDocData = tableDataInfo[pickedIndex]
            vc?.currentDocKey = tableData[pickedIndex]
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
