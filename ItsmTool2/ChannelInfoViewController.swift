//
//  ChannelInfoViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 7/1/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class ChannelInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = []
    let db = Firestore.firestore()
    @IBOutlet weak var channelSettingsButton: UIButton!
    var picked: String = ""
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            print("not nil")
            menuButton = UIBarButtonItem.init(title: "Menu", style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            //set the leftBarButtonItem to the MenuButton
            self.revealViewController().navigationItem.leftBarButtonItem = menuButton
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableView.delegate = self
        tableView.dataSource = self
        fillTableData()
        if(!isAdmin){
            channelSettingsButton.isHidden = true
        }
    }
    
    //fills the table with all the users
    func fillTableData() {
        let docRef = self.db.collection("Access Codes").document(currentAccessCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                for docData in data! {
                    if(docData.key != "company name"){
                        self.tableData.append(docData.key)
                    }
                }
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    //number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    //use the tableData as the source of table data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")
        let text = tableData[indexPath.row]
        cell?.textLabel?.text = text
        return cell!
    }
    
    //Does whatever when the user clicks on a memeber of the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        picked = self.tableData[indexPath.row]
        //show user info
        self.performSegue(withIdentifier: "goToUserInfo", sender: self)
    }
    
    //Send in the user email to the userInfoViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UserInfoViewController {
            let vc = segue.destination as? UserInfoViewController
            vc?.email = picked
        }
    }
    
    @IBAction func goToChannelSettings(_ sender: Any) {
        self.performSegue(withIdentifier: "goToChannelSettings", sender: self)
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
