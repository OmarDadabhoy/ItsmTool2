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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                    self.tableData.append(dataDoc.key)
                    //This will contain the values for each of the keys in tableData
                    self.tableDataValues.append(dataDoc.value)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.tableData[indexPath.row])
        pickedData = self.tableData[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "goToTableData", sender: self)
//        if(self.tableData[indexPath.row] == "Incidents") {
//            self.performSegue(withIdentifier: "goToIncidents", sender: self)
//        } else if(self.tableData[indexPath.row] == "Home") {
//            let channelViewController = ChannelViewController();
//            if channelViewController.viewIfLoaded?.window == nil {
//                // viewController is not visible
//                if let navController = self.navigationController{
//                    navController.popViewController(animated: true)
//                }
//            }
//        }
    }
    
    //Create a new incident
    @IBAction func createNewIncident(_ sender: Any) {
        self.performSegue(withIdentifier: "createNewIncident", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(tableData)
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewIncident" {
            let destinationVC = segue.destination as! CreateNewIncidentViewController
            // Set any variable in ViewController2
            destinationVC.callbackResult = { result in
                self.tableData.append(result)
                // assign passing data etc..
                self.tableView.reloadData()
            }
        }
        if segue.destination is ViewIncidentViewController{
            let vc = segue.destination as? ViewIncidentViewController
            vc?.incidentName = pickedData
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
