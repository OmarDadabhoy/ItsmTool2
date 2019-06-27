//
//  IncidentsViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/26/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit

class IncidentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = []
    
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
        fillTableData()
    }
    
    func fillTableData(){
        
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
    
    //Create a new incident
    @IBAction func createNewIncident(_ sender: Any) {
        self.performSegue(withIdentifier: "createNewIncident", sender: self)
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
