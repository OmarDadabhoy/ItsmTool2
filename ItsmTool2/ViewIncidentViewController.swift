//
//  ViewIncidentViewController.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/27/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import UIKit
import Firebase

class ViewIncidentViewController: UIViewController {
    
    let db = Firestore.firestore()
    var incidentName: String = ""
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var creatorTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var urgencyTextField: UITextField!
    @IBOutlet weak var Descirption: UITextField!
    @IBOutlet weak var resolver: UITextField!
    @IBOutlet weak var resolveIncidentButton: UIButton!
    @IBOutlet weak var closeIncidentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func getData() {
        
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
