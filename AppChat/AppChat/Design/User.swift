//
//  User.swift
//  AppChat
//
//  Created by HaiPhan on 6/2/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import UIKit

class User {
    var id: String!
    var email: String!
    var name: String!
    var pass: String!
    var link_image: String?
    var line_video: String?
//    var width_image: CGFloat?
//    var height_image: CGFloat?
    init() {
        self.email = ""
        self.pass = ""
        self.name = ""
        self.link_image = ""
        self.id = ""
        self.line_video = ""
//        self.width_image = nil
//        self.height_image = nil
    }
    init(email: String, name: String, pass: String, link_image: String, id: String, link_video: String) {
        self.email = email
        self.pass = pass
        self.name = name
        self.link_image = link_image
        self.id = id
        self.line_video = link_video
//        self.width_image = width_image
//        self.height_image = height_image
    }
}
