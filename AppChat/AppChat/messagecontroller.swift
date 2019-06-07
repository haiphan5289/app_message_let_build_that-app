//
//  ViewController.swift
//  AppChat
//
//  Created by HaiPhan on 5/31/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase


class messagecontroller: UIViewController {
    @IBOutlet weak var tblist: UITableView!
    @IBOutlet weak var navibar: UINavigationBar!
    let naviitem: UINavigationItem = UINavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
//        setupnavibarcustom()
        tblist.register(UserCell.self, forCellReuseIdentifier: "cell")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handlelogout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new"), style: .plain, target: self, action: #selector(handlemovetonewmesssage))
        //kiểm tra user có đăng nhập không
        checkuser_inputtitle()
//        get_message()
        
    }
    func get_message_2(){
        guard let uid =  Auth.auth().currentUser?.uid else {
            return
        }
        let table_user_mess = ref.child("user-mess").child(uid)
        table_user_mess.observe(.childAdded) { (snap) in
            let message_id = snap.key
            let table_mess = ref.child("mess").child(message_id)
            //value là lấy giái trị trong key luôn
            table_mess.observeSingleEvent(of: .value, with: { (snap) in
                let message_data = snap.value as! NSDictionary
                let fromID = message_data["fromID"] as! String
                let mess = message_data["mess"] as? String
                let toID = message_data["toID"] as! String
                let timestamp = message_data["timestamp"] as! NSNumber
                let image_url = message_data["image_url"] as? String
                let message : Mess = Mess(toID: toID, fromID: fromID, timestamp: timestamp, mess: mess ?? "", image_url: image_url ?? "")
                
                //group tất cả mess cùng ID lại với nhau
                var toID_2 = message.get_chat_partner_id()
                if  toID_2 != nil{
                    self.message_dictionary[toID_2] = message
                    self.array_mess = Array(self.message_dictionary.values)
                    self.array_mess.sort(by: { (mess1, mess2) -> Bool in
                        return mess1.timestapm.intValue > mess2.timestapm.intValue
                    })
                    self.timer.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handle_call_data), userInfo: nil, repeats: false)
                }
            })
        }
    }
    //Only call 1 time, user Timer
    var timer: Timer = Timer()
    @objc func handle_call_data(){
        print("we're reloaded data")
        self.tblist.reloadData()
    }
    
    var array_mess: [Mess] = [Mess]()
    var message_dictionary: [String: Mess] = [String:Mess]()
    func get_message(){
        let table_mess = ref.child("mess")
        table_mess.observe(.childAdded, with: { (snap) in
            if let message_data = snap.value as? NSDictionary {
                let fromID = message_data["fromID"] as! String
                let mess = message_data["mess"] as? String
                let toID = message_data["toID"] as! String
                let timestamp = message_data["timestamp"] as! NSNumber
                let image_url = message_data["image_url"] as? String
                let message : Mess = Mess(toID: toID, fromID: fromID, timestamp: timestamp, mess: mess ?? "", image_url: image_url ?? "")
                //group tất cả các mess cung id lại với nhau
                //quan trọng
//                let current_user = Auth.auth().currentUser
                var toID_2 = message.get_chat_partner_id()
                if  toID_2 != nil{
                    self.message_dictionary[toID_2] = message
                    self.array_mess = Array(self.message_dictionary.values)
                    self.array_mess.sort(by: { (mess1, mess2) -> Bool in
                        return mess1.timestapm.intValue > mess2.timestapm.intValue
                    })
                }
//                self.array_mess.append(message)
                self.tblist.reloadData()
            }
        }, withCancel: nil)
    }
    //kiểm tra user & input tittle
    func checkuser_inputtitle(){
        if Auth.auth().currentUser == nil {
            performSelector(inBackground: #selector(handlelogout), with: nil)
        }
        else {
//            //hiển thị text mặc định
//            self.navigationItem.title = "loading..."
            let uid = Auth.auth().currentUser
            //lấy dữ liệu của key >>> NS Dictionary
            let tableuser = ref.child("user").child(uid!.uid)
            tableuser.observe(.value) { (snap) in
                let mangtemp = snap.value as? NSDictionary
                let name = mangtemp?["name"] as? String
                let email = mangtemp?["email"] as? String
                let pass = mangtemp?["pass"] as? String
                let link = mangtemp?["Avtar_url"] as? String
                let id = snap.key
                let user: User = User(email: email ?? "emaildemo", name: name ?? "loading....", pass: pass ?? "passdemo", link_image: link ?? "linkdemo", id: id )
//                self.navigationItem.title = user.name
                self.setupnavigationitem(user: user)
            }
        }
    }
    func setupnavigationitem(user: User){
        message_dictionary.removeAll()
        array_mess.removeAll()
        self.tblist.reloadData()
         get_message_2()
        //Tạo view cho title
        let titleview = UIView()
        //nên set-up width là  
        titleview.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        titleview.backgroundColor = .red
        titleview.alpha = 1
        
        //tam thời ẩn code - để check
        //tạo image kế bên title
        let image : UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.load_image(text: user.link_image!, positionx: 20, positiony: 20)
        titleview.addSubview(image)
//        add contraints cho image
        image.leftAnchor.constraint(equalTo: titleview.leftAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: titleview.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //adđ lable
        let textlabel : UILabel = UILabel()
        textlabel.text = user.name
        titleview.addSubview(textlabel)

        //add contraints for textlabel
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        textlabel.leftAnchor.constraint(equalTo: image.rightAnchor).isActive = true
        textlabel.rightAnchor.constraint(equalTo: titleview.rightAnchor).isActive = true
        textlabel.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        textlabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
        self.navigationItem.titleView = titleview
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(move_to_chat_log_controller))
//        titleview.addGestureRecognizer(tap)

    }
    @objc func move_to_chat_log_controller(){
        self.movescreenbynavi(text: "chat_logmessage")
    }
    
    func setupnavibarcustom(){
        naviitem.title = "loading..."
        naviitem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handlelogout))
        navibar.backgroundColor = .white
        //        navibar.backgroundColor =  UIColor(r: 61, g: 91, b: 151)
        navibar.setItems([naviitem], animated: true)
        
        naviitem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new"), style: .plain, target: self, action: #selector(handlemovetonewmesssage))
        //        self.navigationController?.navigationBar.topItem?.title = "Logout"
        //        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "logout")
        //        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "logout")
    }
    
    //hame move to new message
    @objc func handlemovetonewmesssage(){
//        let new = newmessage()
//        let navi = UINavigationController(rootViewController: new)
//        self.present(navi, animated: true, completion: nil)
        self.movescreenbynavi(text: "newmessage")
    }
    
    //hàm để logout
    @objc func handlelogout(){
        do {
            try Auth.auth().signOut()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        self.movescreenbynavi(text: "login")
//        self.movescreen(text: "login")

    }


}
extension messagecontroller: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_mess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserCell
//        cell.textLabel?.text = self.array_mess[indexPath.row].toID
        cell.message = array_mess[indexPath.row]
        cell.detailTextLabel?.text = self.array_mess[indexPath.row].mess
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(move_to_chat_log_controller))
//        self.view.addGestureRecognizer(tap)
        let screeen_chat_log = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chat_logmessage") as! chat_logmessage
//        var chat_partner_id: String
//        if Auth.auth().currentUser?.uid == self.array_mess[indexPath.row].fromID {
//            chat_partner_id = self.array_mess[indexPath.row].toID
//        }
//        else {
//            chat_partner_id = self.array_mess[indexPath.row].fromID
//        }
        //tạo 1 biến để hứng và lấy dữ liệu from mess
        let message = self.array_mess[indexPath.row]
        //lấy chat partner id bằng hàm get chat partner id
        let chat_partner_id = message.get_chat_partner_id()
        //truy cập thông tin partner id = id, để get dữ liệu cho màn hình chat long message
        let table_user_chat_long = ref.child("user").child(chat_partner_id)
        table_user_chat_long.observe(.value, with: { (snap) in
            let mangtemp = snap.value as! NSDictionary
            let email = mangtemp["email"] as! String
            let name = mangtemp["name"] as! String
            let pass = mangtemp["pass"] as! String
            let Avtar_url = mangtemp["Avtar_url"] as! String
            let user: User = User(email: email, name: name, pass: pass, link_image: Avtar_url, id: snap.key)
            screeen_chat_log.user = user
            
        }, withCancel: nil)
        self.navigationController?.pushViewController(screeen_chat_log, animated: true)
//        screeen_chat_log.user = self.array_mess[indexPath.row]
//        print(self.array_mess[indexPath.row].mess)
//        print(self.array_mess[indexPath.row].toID)
//        print(self.array_mess[indexPath.row].fromID)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    
}
extension UIViewController {
    func movescreen(text: String){
        let screen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: text)
        self.present(screen, animated: true, completion: nil)
    }
    func movescreenbynavi(text: String){
        let screen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: text)
        self.navigationController?.pushViewController(screen, animated: true)
    }
    func autolayouttwocontraints(view: UIView,text: String, object1: AnyObject, object2: AnyObject){
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: text, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": object1, "v1": object2]))
    }
    func autolayoutonecontraints(view: UIView,text: String, object: AnyObject){
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: text, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": object]))
    }

}
//class User_Cell: UITableViewCell {
//    var profileImage: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "login")
//        image.layer.cornerRadius = 25
//        image.layer.borderColor = UIColor.blue.cgColor
//        image.layer.borderWidth = 2
//        image.clipsToBounds = true
//        return image
//    }()
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.textLabel?.frame = CGRect(x: 66, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.size.width)!, height: (textLabel?.frame.size.height)!)
//        self.detailTextLabel?.frame = CGRect(x: 66, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.size.width)!, height: (detailTextLabel?.frame.size.height)!)
//    }
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: "cell")
//        addSubview(profileImage)
//        //add contraints
//        profileImage.translatesAutoresizingMaskIntoConstraints = false
//        profileImage.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor, constant: 8).isActive = true
//        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive  = true
//        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

