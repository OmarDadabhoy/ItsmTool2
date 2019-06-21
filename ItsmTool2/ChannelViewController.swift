//
//  ChannelViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/19/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    var accessCode: String = ""
    let tablePicker: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //Sees where the user touched so if they touch outside the menu itll dissapear 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        guard let location = touch?.location(in: self.view) else { return }
//        if !menu.frame.contains(location) {
//            print("Tapped outside the view")
//            UIView.animate(withDuration: 0.3, animations: {
//                self.view.layoutIfNeeded()
//            })
//        }else {
//            print("Tapped inside the view")
//        }
    }
    
//    //number of rows in the table view
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tablePicker.count
//    }
//
//    //sets up the cells of the table
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
//        cell.textLabel?.text = tablePicker[indexPath.row]
//        return cell
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
