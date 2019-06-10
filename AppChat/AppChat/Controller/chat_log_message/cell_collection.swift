//
//  cell_collection.swift
//  AppChat
//
//  Created by HaiPhan on 6/5/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import AVFoundation

class cell_collection: UICollectionViewCell {
    //Khai bai biến để để chat_longmessage call
    var chat_log_controller: chat_logmessage?
    //khơi tạo biến mess để lấy dữ liệu từ chat_logmesssage
    var mess: Mess?
    //steup textview cho cell collection
    let textview: UITextView = {
        let tex = UITextView()
        tex.textColor = UIColor.white
        //font này với fonr ở hàm estimate_frame_for_text (chat_logmessage) phải cùng nhâu, nếu không sẽ bị lệch
        tex.font = UIFont.boldSystemFont(ofSize: 16)
        tex.textAlignment = NSTextAlignment.left
        tex.backgroundColor = UIColor.clear
        tex.isEditable = false
        //        tex.backgroundColor = UIColor.yellow
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
        //        image_avatar.image = UIImage(named: "login")
        image_avatar.layer.cornerRadius  = 16
        image_avatar.contentMode = UIView.ContentMode.scaleAspectFill
        //        image_avatar.clipsToBounds = true
        image_avatar.layer.masksToBounds = true
        return image_avatar
    }()
    //đổi biến Let sang Lazy Var
    lazy var image_chat: UIImageView = {
        let image = UIImageView()
        //        image.image = UIImage(named: "login")
        image.backgroundColor = UIColor.brown
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle_image_zoom)))
        return image
    }()
    
    @objc func handle_image_zoom(tapgesture: UITapGestureRecognizer){
        //tạo 1 biến để lay image khi tap
        if let imageview = tapgesture.view as? UIImageView{
            self.chat_log_controller?.image_chat_zoom(starting_image_view: imageview)
        }
        
    }
    //khơi tạo button play trên image
    //let chuyển sang lazy var thi mới nhấn touch_ínside  
    lazy var play_button: UIButton = {
        let bt = UIButton(type: .system)
        //        bt.backgroundColor = UIColor.red
        bt.tintColor = UIColor.white
        bt.setImage(UIImage(named: "play"), for: .normal)
        bt.addTarget(self, action: #selector(handle_play_video), for: .touchUpInside)
        return bt
    }()
    //xử lý khi User nhấn button pplay
    //đưa biến player ra ngoài để khi scroll chat log UI không bị lỗi
    //Khi scroll xuống video sẽ dừng
    var player: AVPlayer?
    var play_layer: AVPlayerLayer?
    @objc func handle_play_video(){
        guard let video_url = mess?.video_url, let url = URL(string: video_url) else {
            return
        }
        player = AVPlayer(url: url)
        //khơi tạo layer để có thể hiển thi
        play_layer = AVPlayerLayer(player: player)
        //khơi tạo frame cho play_layer mới có hiển thị
        //hàm này vẫn còn bị dính image thumnail nên chưa tối ưu
        //        play_layer.frame = bubbleview.frame
        //dùng buond để tối ưu lại
        play_layer?.frame = bubbleview.bounds
        self.image_chat.isHidden = true
        bubbleview.layer.addSublayer(play_layer!)
        player!.play()
        
    }
    //đưa biến player ra ngoài để khi scroll chat log UI không bị lỗi
    override func prepareForReuse() {
        super.prepareForReuse()
        play_layer?.removeFromSuperlayer()
        player?.pause()
    }
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
        bubbleview.addSubview(play_button)
        
        //Autolayout play button
        play_button.translatesAutoresizingMaskIntoConstraints = false
        play_button.centerXAnchor.constraint(equalTo: bubbleview.centerXAnchor).isActive = true
        play_button.centerYAnchor.constraint(equalTo: bubbleview.centerYAnchor).isActive = true
        play_button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        play_button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
