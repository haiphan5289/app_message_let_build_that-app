//
//  Mess.swift
//  AppChat
//
//  Created by HaiPhan on 6/4/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import Firebase

class Mess {
    var toID : String!
    var fromID: String!
    var timestapm: NSNumber!
    var mess: String?
    var image_url: String?
//    var image_url: String
    init() {
        self.toID = ""
        self.fromID = ""
        self.timestapm = 0
        self.mess = ""
        self.image_url = ""
    }
    init(toID: String, fromID: String, timestamp: NSNumber, mess: String, image_url: String) {
        self.fromID = fromID
        self.mess = mess
        self.toID = toID
        self.timestapm = timestamp
        self.image_url = image_url
    }
    func get_chat_partner_id() -> String{
        let chat_partner_id: String
        if Auth.auth().currentUser?.uid == fromID {
            return toID
        }
        else {
            return fromID
        }
    }
}

