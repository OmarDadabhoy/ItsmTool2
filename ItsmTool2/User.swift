//
//  User.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/25/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var admin: Bool
    var email: String
    var accessCodes: [String]
    
    init(name: String, admin: Bool, email: String, accessCodes: [String]){
        self.name = name
        self.admin = admin
        self.email = email
        self.accessCodes = accessCodes
    }
}
