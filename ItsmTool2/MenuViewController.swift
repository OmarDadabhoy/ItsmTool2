//
//  MenuViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/24/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = ["Home", "Incidents", "Channel Info", "Changes", "Employee Designation", "Go Back To Channel Picker"]
    var tableSections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    //returns the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    //gets the current cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")
        let text = tableData[indexPath.row]
        cell?.textLabel?.text = text
        return cell!
    }
    
    //keeps track of the last clicked and 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.tableData[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if(self.tableData[indexPath.row] == "Incidents") {
            lastClickedMenu = self.tableData[indexPath.row]
            self.performSegue(withIdentifier: "goToIncidents", sender: self)
        } else if(self.tableData[indexPath.row] == "Home") {
            lastClickedMenu = self.tableData[indexPath.row]
            self.performSegue(withIdentifier: "goBackHome", sender: self)
        } else if(self.tableData[indexPath.row] == "Channel Info"){
            lastClickedMenu = self.tableData[indexPath.row]
            self.performSegue(withIdentifier: "goToChannelInfo", sender: self)
        } else if(self.tableData[indexPath.row] == "Changes"){
            lastClickedMenu = self.tableData[indexPath.row]
            self.performSegue(withIdentifier: "goToChanges", sender: self)
        } else if(self.tableData[indexPath.row] == "Go Back To Channel Picker"){
            if let navController = self.navigationController{
                navController.popViewController(animated: true)
            }
        } else if(self.tableData[indexPath.row] == "Employee Designation") {
            if(isAdmin){
                self.performSegue(withIdentifier: "goToEmployeeDesignation", sender: self)
            } else {
                self.performSegue(withIdentifier: "goToEmployeeDesignation2", sender: self)
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
