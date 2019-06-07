//
//  User.swift
//  AppChat
//
//  Created by HaiPhan on 6/2/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation

class User {
    var id: String!
    var email: String!
    var name: String!
    var pass: String!
    var link_image: String?
    init() {
        self.email = ""
        self.pass = ""
        self.name = ""
        self.link_image = ""
        self.id = ""
    }
    init(email: String, name: String, pass: String, link_image: String, id: String) {
        self.email = email
        self.pass = pass
        self.name = name
        self.link_image = link_image
        self.id = id
    }
}
