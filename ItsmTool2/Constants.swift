//
//  Constants.swift
//  ItsmTool2
//
//  Created by Omar Dadabhoy on 6/25/19.
//  Copyright © 2019 Omar Dadabhoy. All rights reserved.
//

import Foundation
import Firebase

var currentAccessCode: String = ""
var userFullName: String = ""
var userEmail: String = ""
var isAdmin: Bool = false

var lastClickedMenu: String = "Home"
let db = Firestore.firestore()
