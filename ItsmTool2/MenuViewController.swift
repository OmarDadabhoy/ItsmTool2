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
    var tableData: [String] = ["Home", "Incidents"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.tableData[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if(self.tableData[indexPath.row] == "Incidents") {
            self.performSegue(withIdentifier: "goToIncidents", sender: self)
        } else if(self.tableData[indexPath.row] == "Home") {
            let channelViewController = ChannelViewController();
            if channelViewController.viewIfLoaded?.window == nil {
                // viewController is not visible
                if let navController = self.navigationController{
                    navController.popViewController(animated: true)
                }
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
