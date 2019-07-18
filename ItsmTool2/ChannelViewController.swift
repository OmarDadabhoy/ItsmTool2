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
    var menuButton: UIBarButtonItem = UIBarButtonItem()
    var backToHomeButton: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            print("not nil")
            menuButton = UIBarButtonItem.init(title: "Menu", style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
//            menuButton = UIBarButtonItem.init(image: , style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            backToHomeButton = UIBarButtonItem.init(title: "Go Back to Channel Picker", style: .plain, target: self, action: #selector(backToHome))
            //set the leftBarButtonItem to the MenuButton
            self.revealViewController().navigationItem.leftBarButtonItem = menuButton
            self.revealViewController()?.navigationItem.rightBarButtonItem = backToHomeButton
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
    
    @objc func backToHome() {
        if let navController = self.navigationController{
            navController.popViewController(animated: true)
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
