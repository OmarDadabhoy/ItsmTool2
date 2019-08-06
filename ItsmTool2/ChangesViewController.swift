//
//  ChangesViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/18/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit

class ChangesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = []
    var tableDataValues: [Any] = []
    var pickedData: String = ""
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        fillTableData()
        refreshControl.addTarget(self, action: #selector(self.handleTopRefresh(_:)), for: .valueChanged )
        // if ios is availble enable refresh control
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            
            self.tableView.addSubview(refreshControl)
            // creating the ui refreshcontrol object
        }
    }
    
    // Configure Refresh Control
    @objc func handleTopRefresh(_ sender:UIRefreshControl){
        self.fillTableData()
    }
    
    //fill the table data with the changes
    func fillTableData(){
        tableData.removeAll()
        tableDataValues.removeAll()
        let docRef = db.collection("Access Code Changes").document(currentAccessCode)
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
                self.refreshControl.endRefreshing()
            } else {
                print("Document does not exist")
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    //allows the user to create a new change
    @IBAction func createNewChange(_ sender: Any) {
        self.performSegue(withIdentifier: "createNewChange", sender: self)
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
        self.performSegue(withIdentifier: "viewChange", sender: self)
    }
    
    //Send change over
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewChange" {
            let vc = segue.destination as? ViewChangeViewController
            vc?.changeName = pickedData
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
