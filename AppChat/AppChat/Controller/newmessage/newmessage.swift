//
//  newmessage.swift
//  AppChat
//
//  Created by HaiPhan on 6/1/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class newmessage: UITableViewController {

    @IBOutlet var tb_newmessage: UITableView!
    var arrayUser: [User] = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handlecancel))
        //khởi tạo hàm này thì mới thực thi hàn Cell for được
        tableView.register(UserCell.self, forCellReuseIdentifier: "cell")
//        self.navigationController?.navigationBar.topItem?.title = "Cancel"
        getdata_fromfirebase()
    }
    
    func getdata_fromfirebase(){
        let tableuser = ref.child("user")
        tableuser.observe(.childAdded) { (snap) in
            let mangtemp = snap.value as! [String:Any]
            let email = mangtemp["email"] as! String
            let pass = mangtemp["pass"] as! String
            let name = mangtemp["name"] as! String
            let link_image = mangtemp["Avtar_url"] as! String
            let id = snap.key
            let user : User = User(email: email ?? "hihi", name: name ?? "namedemo", pass: pass ?? "pasdemo", link_image: link_image ?? "linkdemo", id: id)
            self.arrayUser.append(user)
            //crash app
//            self.tb_newmessage.reloadData()
            //this will crash because of backgroudn thread, so let's is user dispatch to fix
//            let dispatch = DispatchQueue(label: "dispatch", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
//            dispatch.async(execute: {
//                self.tb_newmessage.reloadData()
//            })
            //Lí do dùng dispatch cho reload, vì khi lấy dũw liệu từ server sẽ nặng & lâu, nên lúc này app sẽ bị crash
            //Vì thế phải dùng dispatch để giải quyết vấn đề
            //Luồng relead này được hiểu là; nó sẽ chạy song song vừa lấy dữ
            //async là chạy bất đồng bộ - là sẽ chạy 2 luồng song song
            //syn là chạy đồng độ: gom lại 1 luồng
            //Phải chay = Main , chứ k chạy = Root từ handlemovetonewmesssage
            let dispatch = DispatchQueue(label: "dispatch", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
            dispatch.sync {
                self.tb_newmessage.reloadData()
            }
        
        }
    }

    //handle func handlecancel
    @objc func handlecancel(){
        self.movescreenbynavi(text: "messagecontroller")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayUser.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        cell.textLabel?.text = arrayUser[indexPath.row].name
        cell.detailTextLabel?.text = arrayUser[indexPath.row].email
//        cell.imageView?.contentMode = .scaleToFill
        
        cell.profileImage.load_image(text: arrayUser[indexPath.row].link_image!, positionx: 25, positiony: 25)
  
        return cell
    }
    
    //Setup height for cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //select cell to move chat_log_message
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.movescreenbynavi(text: "chat_logmessage")
        let screen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chat_logmessage") as! chat_logmessage
        screen.user = arrayUser[indexPath.row]
        self.navigationController?.pushViewController(screen, animated: true)
    }
}
//class UserCell: UITableViewCell {
//
//    let profileImageView: UIImageView = {
//        let imaage = UIImageView()
//        //set image mặc đinh
////        imaage.image = UIImage(named: "login")
//        imaage.layer.cornerRadius = 50
//        //set up thuộc tính này thì radius mới hoạt động
//        imaage.clipsToBounds = true
//        imaage.layer.borderColor = UIColor.blue.cgColor
//        return imaage
//    }()
//    override func layoutSubviews() {
//        //thêm  super.layoutSubviews()
//        //để xác định view hiển thị của text label
//        super.layoutSubviews()
//        textLabel?.frame = CGRect(x: 116, y: (textLabel?.frame.origin.y)!, width: textLabel!.frame.size.width, height: textLabel!.frame.size.height)
//        detailTextLabel?.frame = CGRect(x: 116, y: (detailTextLabel?.frame.origin.y)! , width: detailTextLabel!.frame.size.width, height: detailTextLabel!.frame.size.height)
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        //profileimageview sẽ được add vào cell
//        //Nếu viết này thì sẽ được add vào view: addSubview(profileImageView)
//        addSubview(profileImageView)
//        //add contraints for iamge
//        //thêm thuộc tính này mới add contraints có tác dụng
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        //Nếu tăng size thì image sẽ bị tràn ra vì Cell không có tự động giãn
//
//        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
