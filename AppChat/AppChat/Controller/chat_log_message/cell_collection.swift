//
//  cell_collection.swift
//  AppChat
//
//  Created by HaiPhan on 6/5/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class cell_collection: UICollectionViewCell {
    //steup textview cho cell collection
    let textview: UITextView = {
        let tex = UITextView()
        tex.textColor = UIColor.white
        //font này với fonr ở hàm estimate_frame_for_text (chat_logmessage) phải cùng nhâu, nếu không sẽ bị lệch
        tex.font = UIFont.boldSystemFont(ofSize: 16)
        tex.textAlignment = NSTextAlignment.left
        tex.backgroundColor = UIColor.clear
        tex.isEditable = false
        return tex
    }()
    let blueColor = UIColor(r: 61, g: 91, b: 151)
    let bubbleview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    let image_profile: UIImageView = {
        let image_avatar = UIImageView()
        image_avatar.image = UIImage(named: "login")
        image_avatar.layer.cornerRadius  = 16
        image_avatar.contentMode = UIView.ContentMode.scaleAspectFill
        //        image_avatar.clipsToBounds = true
        image_avatar.layer.masksToBounds = true
        return image_avatar
    }()
    let image_chat: UIImageView = {
        let image = UIImageView()
//        image.image = UIImage(named: "login")
        image.backgroundColor = UIColor.brown
        image.contentMode = UIView.ContentMode.scaleAspectFill
        return image
    }()
    //khai báo biến width để chiều ngang tự động kéo giãn
    var bubblewidth: NSLayoutConstraint!
    //khai báo biến bubleleft để textview nằm bên trái or không
    var bubleLeft: NSLayoutConstraint!
    //khai báo biến bubleleft để textview nằm bên phẩi or không
    var bubleRight: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        bubbleview.backgroundColor = blueColor
        addSubview(bubbleview)
        addSubview(textview)
        addSubview(image_profile)
        bubbleview.addSubview(image_chat)
        //Autolayout cho mỗi vỉew của text
        //Mắc định textview sẽ bên phải buble view
        bubbleview.translatesAutoresizingMaskIntoConstraints = false
        bubleLeft = bubbleview.leftAnchor.constraint(equalTo: image_profile.rightAnchor, constant: 8)
        //        bubleLeft.isActive = true
        bubleRight = bubbleview.rightAnchor.constraint(equalTo: self.rightAnchor)
        bubleRight.isActive = true
        bubbleview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //        bubbleview.widthAnchor.constraint(equalToConstant: 400).isActive = true
        bubblewidth = bubbleview.widthAnchor.constraint(equalToConstant: 200)
        bubblewidth.isActive = true
        bubbleview.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        ///Autaolayoutcho text view
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.rightAnchor.constraint(equalTo: bubbleview.rightAnchor).isActive = true
        textview.centerYAnchor.constraint(equalTo: bubbleview.centerYAnchor).isActive = true
//        textview.widthAnchor.constraint(equalTo: bubbleview.widthAnchor).isActive = true
        textview.heightAnchor.constraint(equalTo: bubbleview.heightAnchor).isActive = true
                textview.leftAnchor.constraint(equalTo: bubbleview.leftAnchor).isActive = true
        //        textview.centerXAnchor.constraint(equalTo: bubbleview.centerXAnchor).isActive = true
        //        textview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //        textview.rightAnchor.constraint(equalTo: bubbleview.rightAnchor).isActive = true
        
        
        //Autolayout cho image
        image_profile.translatesAutoresizingMaskIntoConstraints = false
        image_profile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        image_profile.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        image_profile.widthAnchor.constraint(equalToConstant: 32).isActive = true
        image_profile.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //autolayout chat image
        image_chat.translatesAutoresizingMaskIntoConstraints = false
        image_chat.leftAnchor.constraint(equalTo: bubbleview.leftAnchor, constant: 0).isActive = true
        image_chat.topAnchor.constraint(equalTo: bubbleview.topAnchor, constant: 0).isActive = true
        image_chat.widthAnchor.constraint(equalTo: bubbleview.widthAnchor).isActive = true
        image_chat.heightAnchor.constraint(equalTo: bubbleview.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
