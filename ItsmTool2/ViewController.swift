//
//  ViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/7/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
    
    //send the email value to the home view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeViewController {
            let vc = segue.destination as? HomeViewController
            vc?.email = self.email
        }
    }
}

