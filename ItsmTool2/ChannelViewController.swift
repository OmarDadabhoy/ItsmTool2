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
    @IBOutlet weak var tableViewLeadingConst: NSLayoutConstraint!
    var tableViewIsHidden: Bool = true
    @IBOutlet weak var menu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showMenu(_ sender: Any) {
        if(tableViewIsHidden){
            tableViewLeadingConst.constant = 0
            tableViewIsHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            tableViewLeadingConst.constant = -240
            tableViewIsHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    //Sees where the user touched so if they touch outside the menu itll dissapear 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !menu.frame.contains(location) {
            print("Tapped outside the view")
            tableViewLeadingConst.constant = -240
            tableViewIsHidden = true
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else {
            print("Tapped inside the view")
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
