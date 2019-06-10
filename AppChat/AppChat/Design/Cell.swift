//
//  Cell.swift
//  AppChat
//
//  Created by HaiPhan on 6/4/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Mess? {
        didSet{
            setup_name_and_avatar()
            let second = message?.timestapm.doubleValue
            let timestampdate = NSDate(timeIntervalSince1970: second!)
            let dateformat = DateFormatter()
            dateformat.dateFormat = "hh:mm:ss a"
            self.timestapm_label.text = dateformat.string(from: timestampdate as Date)
        }
    }
    
    private func setup_name_and_avatar(){
        var chat_partner_id : String?
        //so sánh, nếu current uid mà = from id từ mess char partner sẽ lấy to_id
//        message?.get_chat_partner_id()
        let to_ID = message?.get_chat_partner_id()
        let table_toID = ref.child("user").child(to_ID!)
        table_toID.observe(.value, with: { (snap) in
            let mangtemp = snap.value as! NSDictionary
            let name = mangtemp["name"] as! String
            let link_avatar = mangtemp["Avtar_url"] as! String
            self.textLabel?.text = name
            self.profileImage.load_image(text: link_avatar , positionx: 25, positiony: 25)
        }, withCancel: nil)
        
    }
    var timestapm_label: UILabel = UILabel()
    
    var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "login")
        image.layer.cornerRadius = 25
        image.layer.borderColor = UIColor.blue.cgColor
        image.layer.borderWidth = 2
        image.clipsToBounds = true
        return image
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.frame = CGRect(x: 66, y: (textLabel?.frame.origin.y)!, width: 200, height: (textLabel?.frame.size.height)!)
        self.detailTextLabel?.frame = CGRect(x: 66, y: (detailTextLabel?.frame.origin.y)!, width: 200, height: (detailTextLabel?.frame.size.height)!)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "cell")
        addSubview(profileImage)
        setup_autolayour_timestamp()
        //add contraints
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive  = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //steup & add contrain timestamp
    func setup_autolayour_timestamp(){
        timestapm_label.text = "jhihi"
        timestapm_label.font = UIFont.systemFont(ofSize: 13)
        timestapm_label.textColor = UIColor.darkGray
        timestapm_label.textAlignment = .right
        addSubview(timestapm_label)
        
        timestapm_label.translatesAutoresizingMaskIntoConstraints = false
        timestapm_label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timestapm_label.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        timestapm_label.heightAnchor.constraint(equalTo: detailTextLabel!.heightAnchor, multiplier: 1).isActive = true
        timestapm_label.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
