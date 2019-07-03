//
//  IncidentsViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/26/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class IncidentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = []
    let db = Firestore.firestore()
    var tableDataValues: [Any] = []
    var pickedData: String = ""
    var tempTableData: [String] = []
    var tempTableDataValues: [Any] = []
    @IBOutlet weak var seeOnlyYourIncidentsButton: UIButton!
    @IBOutlet weak var viewAllIncidentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewAllIncidentsButton.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        self.fillTableData()
        if self.revealViewController() != nil {
            print("not nil")
            menuButton = UIBarButtonItem.init(title: "Menu", style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            //            menuButton = UIBarButtonItem.init(image: , style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            //set the leftBarButtonItem to the MenuButton
            self.revealViewController().navigationItem.leftBarButtonItem = menuButton
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //Fills the table with the incidents
    func fillTableData(){
        print(currentAccessCode)
        let docRef = db.collection("Access Code Incidents").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                //loop through the data and add all the keys/incident names to the table data
                for dataDoc in data! {
//                    self.tableData.append(dataDoc.key)
//                    //This will contain the values for each of the keys in tableData
//                    self.tableDataValues.append(dataDoc.value)
                    self.addTableDataBasedOfDate(dataDocKey: dataDoc.key, dataDocVal: dataDoc.value as! [String])
                }
                print(self.tableData)
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //sorts the table data by date
    private func addTableDataBasedOfDate(dataDocKey: String, dataDocVal: [String]){
        if(tableData.count == 0){
            tableData.append(dataDocKey)
            tableDataValues.append(dataDocVal)
        } else {
            //we want to turn the current date which we want to answer into a date object
            let date: String = dataDocVal[1]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
            let finalDate = dateFormatter.date(from: date)
            //create an index for the loop
            var i: Int = 0
            var found: Bool = false
            //loop through until we have either found an element which our date is less than or there are values availbal
            while(!found && i < tableDataValues.count) {
                let currentDataVal = tableDataValues[i] as! [String]
                let currentDate: String = currentDataVal[1]
                let currentFinalDate = dateFormatter.date(from: currentDate)
                //once our finalDate is less than the current we can break out of the loop because it belongs here
                if((finalDate!) < (currentFinalDate!)){
                    found = true
                }
                i += 1
            }
            tableData.insert(dataDocKey, at: (i - 1))
            tableDataValues.insert(dataDocVal, at: (i - 1))
        }
        print(tableData)
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
        print(self.tableData[indexPath.row])
        pickedData = self.tableData[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "goToTableData", sender: self)
    }
    
    //Create a new incident
    @IBAction func createNewIncident(_ sender: Any) {
        self.performSegue(withIdentifier: "createNewIncident", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    //Reload table when we open this
    override func viewWillAppear(_ animated: Bool) {
        print(tableData)
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    //Contains segue info
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if we are creating a new incident make sure they pass back the incident name and put it in the tableView
        if segue.identifier == "createNewIncident" {
            let destinationVC = segue.destination as! CreateNewIncidentViewController
            // Set any variable in ViewController2
            destinationVC.callbackResult = { result in
                self.addTableDataBasedOfDate(dataDocKey: result, dataDocVal: [])
                // assign passing data etc..
                self.tableView.reloadData()
            }
        }
        //if the user deletes a piece of data and send it back then go through and find it and remove it
        if segue.identifier == "goToTableData" {
            let destinationVC = segue.destination as! ViewIncidentViewController
            // Set any variable in ViewController2
            destinationVC.callbackResult = { result in
                var found: Bool = false
                var i: Int = 0
                while(!found && i < self.tableData.count){
                    if(result == self.tableData[i]){
                        found = true
                    }
                    i += 1
                }
                if(found){
                    self.tableData.remove(at: (i - 1))
                }
                // assign passing data etc..
                self.tableView.reloadData()
            }
        }
        //if the we are viewing an incident pass in the incidentName to the pickedData
        if segue.destination is ViewIncidentViewController{
            let vc = segue.destination as? ViewIncidentViewController
            vc?.incidentName = pickedData
        }
    }
    
    //Click this to only see your incidents
    @IBAction func seeOnlyYOurIncidents(_ sender: Any) {
        fillTempArrays()
        tableData.removeAll()
        tableDataValues.removeAll()
        self.db.collection("Access Code Incidents").document(currentAccessCode).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                for dataDoc in data! {
                    let dataDocValue = dataDoc.value as! [String]
                    if(dataDocValue[4] == userEmail || dataDocValue[5] == userEmail) {
                        self.tableData.append(dataDoc.key)
                    }
                }
                self.tableView.reloadData()
            } else {
                print("Doc not found")
            }
        }
        self.seeOnlyYourIncidentsButton.isHidden = true
        self.viewAllIncidentsButton.isHidden = false
    }
    
    //Fill the temporary arrays with the current data
    private func fillTempArrays() {
        tempTableData.removeAll()
        tempTableDataValues.removeAll()
        for data in tableData {
            tempTableData.append(data)
        }
        for data in tableDataValues{
            tempTableDataValues.append(data)
        }
    }
    
    //go back to viewing all incidents 
    @IBAction func viewAllIncidents(_ sender: Any) {
        fillNonTempArraysAgain()
        self.seeOnlyYourIncidentsButton.isHidden = false
        self.viewAllIncidentsButton.isHidden = true
    }
    
    //fills the non temp arrays again if the user chooses to view all incidents
    private func fillNonTempArraysAgain(){
        tableData.removeAll()
        tableDataValues.removeAll()
        for data in tempTableData{
            tableData.append(data)
        }
        for data in tempTableDataValues{
            tableDataValues.append(data)
        }
        self.tableView.reloadData()
        tempTableData.removeAll()
        tempTableDataValues.removeAll()
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
