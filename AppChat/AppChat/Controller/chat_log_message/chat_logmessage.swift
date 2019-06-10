//
//  chat_logmessage.swift
//  AppChat
//
//  Created by HaiPhan on 6/3/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase
//import 2 thư việc này để trỏ tới album gồm: image & video của devices
import MobileCoreServices
import AVFoundation

private let reuseIdentifier = "Cell"

class chat_logmessage: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var view_ui: UIView = UIView()
    var txt_text: UITextField = UITextField()
    var button_send: UIButton = UIButton(type: .contactAdd)
    var image_upload: UIImageView = UIImageView()
    var user: User? {
        didSet {
            //set title screen = user.name
            self.navigationItem.title = user?.name
            get_message_user_partner()
        }
    }
    var array_message: [Mess] = [Mess]()
    func get_message_user_partner(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let table_user_mess = ref.child("user-mess").child(uid)
        table_user_mess.observe(.childAdded, with: { (snap) in
            let partner_id = snap.key
            let table_user_mess_partner = ref.child("user-mess").child(uid).child(partner_id)
            table_user_mess_partner.observe(.childAdded, with: { (snap) in
                let  key_message = snap.key
                let table_mess = ref.child("mess").child(key_message)
                table_mess.observe(.value, with: { (snap) in
                    let mangtemp = snap.value as! NSDictionary
                    let fromID = mangtemp["fromID"] as! String
                    let mess = mangtemp["mess"] as? String
                    let timestamp = mangtemp["timestamp"] as! NSNumber
                    let toID = mangtemp["toID"] as! String
                    let image_url = mangtemp["image_url"] as? String
                    let video_url = mangtemp["video_url"] as? String
                    let data: Mess = Mess(toID: toID, fromID: fromID, timestamp: timestamp, mess: mess ?? "", image_url:  image_url ?? "", video_url: video_url ?? "")
                    //Step 1: Trỏ tới database "mess" và fetch ra tất cả dữ liệu của snap.key
                    //Step 2: tìm điều kiện để fetch data cho current_user & partner
                    //Step 3: tìm id để so sánh với user.id
                    //Step 4: id đó là toDI or fromID
                    if  data.get_chat_partner_id() == self.user?.id {
                        self.array_message.append(data)
                        self.collectionView.reloadData()
                        let indexPath = NSIndexPath(item: self.array_message.count - 1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                    }
                }, withCancel: nil)
            })
        }, withCancel: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //cach top của mỗi text với  
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
        collectionView.alwaysBounceVertical = true
        //set up cell sẽ được đièu khiển bởi thư mục nào
        self.collectionView!.register(cell_collection.self, forCellWithReuseIdentifier: reuseIdentifier)
        view_mesage_autolayout()
        set_up_and_autolayout_image_upload()
        set_up_and_autolayout_txt_text()
        button_send_autolayout()
        text_field_move_when_input_keyboard()
        //        collectionview_autolayout()
        //        send_button_autolayout()
        //        txt_mess_autolayout()
        txt_text.delegate = self
    }
    //Di chuyển txtfield khi keyboard apppears
    func text_field_move_when_input_keyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(handle_keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handle_keyboard_hidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func handle_keyboard(notification: NSNotification){
        //print cach bottom cua keyboard
        let keyboard_frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboard_duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        botton_view_ui.constant = -keyboard_frame.height
        UIView.animate(withDuration: keyboard_duration) {
            self.view.layoutIfNeeded()
        }
    }
    //Keyboard an?, view contant = 0
    @objc func handle_keyboard_hidden(){
        botton_view_ui.constant = 0
        
    }
    
    //Autolayout UICollectionView
    //    func collectionview_autolayout(){
    //        collectionView.translatesAutoresizingMaskIntoConstraints = false
    //        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    //        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    //        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    //        collectionView.bottomAnchor.constraint(equalTo: view_message.topAnchor).isActive = true
    //    }
    
    //Autolayout & Set-up view mesage
    var botton_view_ui: NSLayoutConstraint!
    func view_mesage_autolayout(){
        view_ui.layer.borderColor = UIColor.black.cgColor
        view_ui.layer.borderWidth = 1
        view_ui.backgroundColor = UIColor.white
        collectionView.addSubview(view_ui)
        
        view_ui.translatesAutoresizingMaskIntoConstraints = false
        view_ui.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        botton_view_ui = view_ui.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: 0)
        botton_view_ui.isActive = true
        view_ui.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        view_ui.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //    func view_mesage_autolayout(){
        //        collectionView.addSubview(view_ui)
        //        view_message.layer.borderColor = UIColor.black.cgColor
        //        view_message.layer.borderWidth = 1
        //        view_message.translatesAutoresizingMaskIntoConstraints = false
        //        view_message.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //        view_message.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //        view_message.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        view_message.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //setup & autolayout for image
    func set_up_and_autolayout_image_upload(){
        image_upload.image = UIImage(named: "gallery")
        image_upload.translatesAutoresizingMaskIntoConstraints = false
        image_upload.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle_image)))
        image_upload.isUserInteractionEnabled = true
        view_ui.addSubview(image_upload)
        
        image_upload.translatesAutoresizingMaskIntoConstraints = false
        image_upload.leftAnchor.constraint(equalTo: view_ui.leftAnchor, constant: 8).isActive = true
        image_upload.centerYAnchor.constraint(equalTo: view_ui.centerYAnchor).isActive = true
        image_upload.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image_upload.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    @objc func handle_image(){
        let image_picker: UIImagePickerController = UIImagePickerController()
        image_picker.delegate = self
        //trơ tới thu việc gôm image & video devices
        image_picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        image_picker.allowsEditing = true
        present(image_picker, animated: true, completion: nil)
    }
    //Set-up & Autolayout button send
    func button_send_autolayout(){
        button_send.setTitle("Send", for: .highlighted)
        //        button_send.tintColor = .darkGray
        //        button_send.backgroundColor = .blue
        button_send.addTarget(self, action: #selector(send_data_to_Firebase), for: .touchUpInside)
        view_ui.addSubview(button_send)
        button_send.translatesAutoresizingMaskIntoConstraints = false
        
        button_send.rightAnchor.constraint(equalTo: view_ui.rightAnchor, constant: -10).isActive = true
        button_send.centerYAnchor.constraint(equalTo: view_ui.centerYAnchor).isActive = true
        button_send.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    @objc func send_data_to_Firebase(){
        let table_mess = ref.child("mess").childByAutoId()
        let toID = user!.id
        let fromID = Auth.auth().currentUser?.uid
        let timestamp : NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let data = ["mess": txt_text.text!, "toID": toID ?? "demo_toID" , "fromID": fromID ?? "demo_from_ID",  "timestamp": timestamp] as [String : Any]
        //        table_mess.setValue(data)
        table_mess.updateChildValues(data) { (err, res) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
                return
            }
            self.txt_text.text = nil
            let table_user_mess = ref.child("user-mess").child(fromID!).child(toID!)
            let key = table_mess.key
            table_user_mess.updateChildValues(["\(key!)" : 1])
            let table_mess_toID = ref.child("user-mess").child(toID!).child(fromID!)
            table_mess_toID.updateChildValues(["\(key!)" : 1])
        }
    }
    //Autolayout & Set-up button send message
    //    func send_button_autolayout(){
    //        send_bt.imageView?.contentMode = .scaleAspectFill
    //        send_bt.setImage(UIImage(named: "send"), for: .normal)
    //        send_bt.translatesAutoresizingMaskIntoConstraints = false
    //        send_bt.rightAnchor.constraint(equalTo: view_message.rightAnchor, constant: -10).isActive = true
    //        send_bt.centerYAnchor.constraint(equalTo: view_message.centerYAnchor).isActive = true
    //        send_bt.widthAnchor.constraint(equalToConstant: 50).isActive = true
    //    }
    
    //    @IBAction func send_message_firebase(_ sender: UIButton) {
    //        let table_mess = ref.child("mess").childByAutoId()
    //        let toID = user!.id
    //        let fromID = Auth.auth().currentUser?.uid
    //        let timestamp : NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
    //        let data = ["mess": txt_mess.text!, "toID": toID , "fromID": fromID,  "timestamp": timestamp] as [String : Any]
    ////        table_mess.setValue(data)
    //
    //        table_mess.updateChildValues(data) { (err, res) in
    //            if err != nil {
    //                print(err?.localizedDescription)
    //                return
    //            }
    //            self.txt_mess.text = nil
    //            let table_user_mess = ref.child("user-mess").child(fromID!)
    //            let key = table_mess.key
    //            table_user_mess.updateChildValues(["\(key!)" : 1])
    //            let table_mess_toID = ref.child("user-mess").child(toID!)
    //            table_mess_toID.updateChildValues(["\(key!)" : 1])
    //        }
    //    }
    
    
    func set_up_and_autolayout_txt_text(){
        txt_text.placeholder = " Enter message...."
        txt_text.attributedPlaceholder = NSAttributedString(string: txt_text.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        //        txt_text.textColor = UIColor.green
        view_ui.addSubview(txt_text)
        
        txt_text.translatesAutoresizingMaskIntoConstraints = false
        txt_text.leftAnchor.constraint(equalTo: image_upload.rightAnchor, constant: 8).isActive = true
        txt_text.centerYAnchor.constraint(equalTo: view_ui.centerYAnchor).isActive = true
        txt_text.rightAnchor.constraint(equalTo: view_ui.rightAnchor, constant: -68).isActive = true
        
    }
    
    //autolayout text field
    //    func txt_mess_autolayout(){
    //        txt_mess.placeholder = " Enter message... "
    //        txt_mess.translatesAutoresizingMaskIntoConstraints = false
    //        txt_mess.leftAnchor.constraint(equalTo: view_message.leftAnchor, constant: 10).isActive = true
    //        txt_mess.centerYAnchor.constraint(equalTo: view_message.centerYAnchor).isActive = true
    //        txt_mess.rightAnchor.constraint(equalTo: send_bt.leftAnchor, constant: -10).isActive = true
    //    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.array_message.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! cell_collection
        cell.textview.text = self.array_message[indexPath.row].mess
        //truyền dữ liệu vào biến Mess để ben cell_Collection xài
        let mess = self.array_message[indexPath.row]
        cell.mess = mess
        //khởi báo biên diều khiên chat log
        cell.chat_log_controller = self
        //điều chỉnh chiều ngang của text
        if self.array_message[indexPath.row].mess != "" {
            cell.bubblewidth.constant = estimate_frame_for_text(text: self.array_message[indexPath.row].mess!).width + 20
            cell.image_chat.isHidden = true
            cell.textview.text = self.array_message[indexPath.row].mess
        }
        //Set -up width nếu cell là image chat
        let string_imageurl = self.array_message[indexPath.row].image_url
        if string_imageurl != ""{
            cell.image_chat.load_image(text: string_imageurl!, positionx: 125, positiony: 125)
            //            cell.image_chat.image = UIImage(named: "login")
            cell.image_chat.isHidden = false
            cell.bubblewidth.constant = 250
            cell.textview.isHidden = true
            //            cell.textview.isEditable = true
        }
        
        let message = self.array_message[indexPath.row]
        //Sset-up 2 màu cho fromid & toid
        if let profile_image_user = self.user?.link_image {
            cell.image_profile.load_image(text: profile_image_user, positionx: 8, positiony: 8)
        }
        if message.fromID == Auth.auth().currentUser?.uid {
            cell.bubbleview.backgroundColor = cell.blueColor
            cell.image_profile.isHidden = true
            cell.bubleRight.constant = -8
            cell.bubleRight.isActive = true
            cell.bubleLeft.isActive = false
        }
        else {
            cell.bubbleview.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textview.textColor = UIColor.black
            cell.bubleRight.isActive = false
            cell.bubleLeft.isActive = true
            cell.image_profile.isHidden = false
        }//viết gọn hơn nữa
        cell.play_button.isHidden = self.array_message[indexPath.row].video_url == ""
//        if self.array_message[indexPath.row].video_url != "" {
//            cell.play_button.isHidden = false
//        }
//        else {
//            cell.play_button.isHidden = true
//        }
        return cell
    }
    var starting_frame: CGRect?
    var background: UIView?
    //handle from chat_log_controller , cell_collection/ handle_image_zoom
    func image_chat_zoom(starting_image_view: UIImageView){
        //Convert image ra các toạ độ
        starting_frame = starting_image_view.superview?.convert(starting_image_view.frame, to: nil)
        //tạo biến zoom view
        let zoom_view = UIImageView(frame: starting_frame!)
        zoom_view.backgroundColor = UIColor.red
        zoom_view.image = starting_image_view.image
        zoom_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle_background_dimisss)))
        zoom_view.isUserInteractionEnabled = true
        
        if let key_window = UIApplication.shared.keyWindow {
            //add uiview back cho key window
            background = UIImageView(frame: CGRect(x: 0, y: 0, width: key_window.frame.width, height: key_window.frame.height))
            background?.backgroundColor = UIColor.black
            background?.alpha = 0
            key_window.addSubview(background!)
            key_window.addSubview(zoom_view)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                //set up height
                //Scale image
                let height = zoom_view.frame.height / zoom_view.frame.width * key_window.frame.width
                zoom_view.frame = CGRect(x: 0, y: 0, width: key_window.frame.width , height: height)
                zoom_view.center = key_window.center
                self.background!.alpha = 1
                key_window.backgroundColor = UIColor.black
                self.view_ui.isHidden = true
                //để user không thể click hình khác được
                self.collectionView.isHidden = true
            }, completion: nil)
        }
    }
    //remove zoom view về lại như ban đầu
    @objc func handle_background_dimisss(tap: UITapGestureRecognizer){
        if let image_zoom_view = tap.view {
            image_zoom_view.frame = starting_frame!
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.background?.alpha = 0
                self.view_ui.alpha = 1
                
            }) { (completioned: Bool) in
                image_zoom_view.removeFromSuperview()
                self.view_ui.isHidden = false
                self.collectionView.isHidden = false
                
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
        
    }
    //set up mỗi cell có chiều ngang = view, height = 80
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        //get estimate height forr text
        let text = self.array_message[indexPath.row].mess
        height = estimate_frame_for_text(text: text!).height + 20
        //set-up height cho cell với dữ liệu là image
        let string_image = self.array_message[indexPath.row].image_url
        if string_image != ""{
            height = 250
        }
        
        return CGSize(width: view.frame.size.width, height: height)
    }
    
    //height của cell sẽ phụ thuộc vào chiều dài của text
    private func estimate_frame_for_text(text: String) -> CGRect {
        let size = CGSize(width: self.view.frame.size.width - 100, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], context: nil)
    }
    //khi quay autolayout sẽ k mất
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    //upload & dowload image về link
    //Đưa biến vào completion để ở hàm khác gọi
    func upload_image_chat_to_firebase(image: UIImage, completion: @escaping (String) -> (String)){
        let random = Int.random(in: 0...10000)
        let image_storage = storage.child("Chat_image:" + "\(String(describing: Auth.auth().currentUser?.email!))" + "\(user?.email!)" + "/\(random)" + ".jpg")
        let image_data = image.pngData()
        image_storage.putData(image_data!, metadata: nil) { (metadata, err) in
            if err != nil {
                print(err?.localizedDescription ?? "hhi")
                return
            }
            image_storage.downloadURL(completion: { (url, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "hihi")
                    return
                }
                let image_url = url?.absoluteString
                completion(image_url!)
               
                
            })
        }
    }
    func upload_video_to_firebase(video_url: NSURL){
        let random = Int.random(in: 0...10000)
        let storage_movie = storage.child("movie:/\(random)")
        let upload_url = storage_movie.putFile(from: video_url as URL, metadata: nil) { (medata, err) in
            if err != nil {
                print(err?.localizedDescription)
            }
            storage_movie.downloadURL(completion: { (url, err) in
                if err != nil {
                    print(err?.localizedDescription)
                }
                //lấy thumnail của video
                let thumnail_image = self.thumnail_image_for_file_url(file_url: video_url)
                self.upload_image_chat_to_firebase(image: thumnail_image, completion: { (image_url) -> (String) in
                    let link_video = url?.absoluteString
                    let fromID = Auth.auth().currentUser?.uid
                    let toID = self.user?.id
                    let table_mess = ref.child("mess").childByAutoId()
                    let timestamp : NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                    let data = ["link_video": link_video ?? "link_video" , "toID": toID ?? "demo_toID" , "fromID": fromID ?? "demo_from_ID",  "timestamp": timestamp, "mess": nil, "image_url": image_url, "video_url": link_video] as [String : Any?]
                    table_mess.updateChildValues(data, withCompletionBlock: { (err, res) in
                        if err != nil {
                            print(err?.localizedDescription ?? "hihi")
                            return
                        }
                        self.txt_text.text = nil
                        let table_user_mess = ref.child("user-mess").child(fromID!)
                        let key = table_mess.key
                        table_user_mess.updateChildValues(["\(key!)" : 1])
                        let table_mess_toID = ref.child("user-mess").child(toID!)
                        table_mess_toID.updateChildValues(["\(key!)" : 1])
                    })
                    return("=============")

                })
            })
        }
        upload_url.observe(.progress) { (snap) in
            if let CompleteUnitCount = snap.progress?.completedUnitCount {
                self.navigationItem.title = String(CompleteUnitCount)
            }
        }
        upload_url.observe(.success) { (snap) in
            self.navigationItem.title = self.user?.name
        }
    }
    //khởi tạo hàm, để lấy thumnail của video
    private func thumnail_image_for_file_url(file_url: NSURL) -> UIImage{
        let asset = AVAsset(url: file_url as URL)
        let image_generator = AVAssetImageGenerator(asset: asset)
        let thumnail_CGImage = try? image_generator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
        return UIImage(cgImage: thumnail_CGImage!)

    }
    
}
extension chat_logmessage: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let video_url = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            upload_video_to_firebase(video_url: video_url)
        }
        else {
            let choose_image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            upload_image_chat_to_firebase(image: choose_image)
            upload_image_chat_to_firebase(image: choose_image) { (image_url) -> (String) in
                let table_mess = ref.child("mess").childByAutoId()
                let toID = self.user!.id
                let fromID = Auth.auth().currentUser?.uid
                let timestamp : NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
                //                print(image.size.width)
                //                print(image.size.height)
                //Nếu muốn tấm hình hiển thị size động thì thêm 2 biến Width & Height vào database
                let data = ["image_url": image_url ?? "demo_image" , "toID": toID ?? "demo_toID" , "fromID": fromID ?? "demo_from_ID",  "timestamp": timestamp, "mess": nil] as! [String : Any]
                //        table_mess.setValue(data)
                
                table_mess.updateChildValues(data) { (err, res) in
                    if err != nil {
                        print(err?.localizedDescription ?? "hihi")
                        return
                    }
                    self.txt_text.text = nil
                    let table_user_mess = ref.child("user-mess").child(fromID!).child(toID!)
                    let key = table_mess.key
                    table_user_mess.updateChildValues(["\(key!)" : 1])
                    let table_mess_toID = ref.child("user-mess").child(toID!).child(fromID!)
                    table_mess_toID.updateChildValues(["\(key!)" : 1])
                }
                return ("=================")
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
}
