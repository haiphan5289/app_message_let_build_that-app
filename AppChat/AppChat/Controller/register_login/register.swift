//
//  login.swift
//  AppChat
//
//  Created by HaiPhan on 5/31/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase

let ref = Database.database().reference(fromURL: "https://appchatfromletbuild.firebaseio.com/")
let storage = Storage.storage().reference()

class register: UIViewController {
    
    let uicontainview = UIView()
    var buttonRegister: UIButton = UIButton()
    var txtname: UITextField! = UITextField()
    var nameseparator: UIView! = UIView()
    var emailseparator: UIView! = UIView()
    var txtemail: UITextField! = UITextField()
    var passseparator: UIView! = UIView()
    var txtpass: UITextField! = UITextField()
    var heightuicontainview: CGFloat!
    var imagelogin: UIImageView! = UIImageView()
    var loginsegment: UISegmentedControl! = UISegmentedControl()
    var buttonlogin: UIButton = UIButton()
    var dowload_url: String!
    var imagedata: Data!
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up color for background
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        heightuicontainview = 150
        createview()
        imagedata = imagelogin.image?.pngData()
    }
    
    //khởi tạo view
    func createview(){
        uicontainview.backgroundColor = .white
        view.addSubview(uicontainview)
        autolayoutcontainview()
        autuolayoutseparator()
        autolayouttxtname()
        autolayoutemailseparator()
        passseparatorautolayout()
        imageautolayout()
        btloginautolayout()
//        loginsegmentcontrolautolayout()
    }
    
    //autolayout button login
    func btloginautolayout(){
        buttonlogincreate()
        buttonlogin.translatesAutoresizingMaskIntoConstraints = false
        buttonlogin.topAnchor.constraint(equalTo: buttonRegister.bottomAnchor, constant: 12).isActive = true
        autolayoutonecontraints(view: view, text: "H:|-12-[v0]-12-|", object: buttonlogin)
        autolayoutonecontraints(view: view, text: "V:[v0(30)]", object: buttonlogin)
    }
    
    //khởi tạo button login
    func buttonlogincreate(){
        buttonlogin = UIButton(type: .system)
        buttonlogin.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        buttonlogin.setTitle("Login", for: .normal)
        buttonlogin.setTitleColor(UIColor.white, for: .normal)
        buttonlogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonlogin.layer.cornerRadius = 5
        buttonlogin.clipsToBounds = true
        buttonlogin.addTarget(self, action: #selector(move), for: .touchUpInside)
        view.addSubview(buttonlogin)
    }
    
    //move to loginreal screen
    @objc func move(){
        self.movescreenbynavi(text: "login")
    }
    
    //khơi toạ autolayout segment control
    func loginsegmentcontrolautolayout(){
        loginsegmentcontrolcreate()
        loginsegment.translatesAutoresizingMaskIntoConstraints = false
        autolayoutonecontraints(view: view, text: "H:|-12-[v0]-12-|", object: loginsegment)
        autolayoutonecontraints(view: view, text: "V:[v0(30)]", object: loginsegment)
        loginsegment.bottomAnchor.constraint(lessThanOrEqualTo: uicontainview.topAnchor, constant: -12).isActive = true
    }
    
    //khơi toạ segment control
    func loginsegmentcontrolcreate(){
        loginsegment = UISegmentedControl(items: ["Login", "Register"])
        loginsegment.tintColor = .white
        loginsegment.selectedSegmentIndex = 1
        loginsegment.addTarget(self, action: #selector(handleloginbutton), for: .valueChanged)
        view.addSubview(loginsegment)
    }
    //xủ lý khi click value segment
    @objc func handleloginbutton(){
        //thay đổi title của button
        let title = loginsegment.titleForSegment(at: loginsegment.selectedSegmentIndex)
        buttonRegister.setTitle(title, for: .normal)
        //change height của uicontain
        heightuicontain?.constant = loginsegment.selectedSegmentIndex == 0 ? 100 : 150
        //change height của name
        heightname?.isActive = false
        heightname = txtname.heightAnchor.constraint(equalTo: uicontainview.heightAnchor, multiplier: loginsegment.selectedSegmentIndex == 0 ? 0 : 1/3)
        heightname?.isActive = true
        nameseparator.removeFromSuperview()
        txtemail.frame.origin.y = loginsegment.selectedSegmentIndex == 0 ? 0 : 0
        print(txtemail.frame.origin.x)
                print(txtemail.frame.origin.y)
        print(txtname.frame.origin.x)
                print(txtname.frame.origin.y)
        
    }
    
    
    //Autolayout image
    func imageautolayout(){
        imagecreate()
        imagelogin.translatesAutoresizingMaskIntoConstraints = false
        imagelogin.bottomAnchor.constraint(equalTo: uicontainview.topAnchor, constant: -52).isActive = true
        autolayoutonecontraints(view: view, text: "V:[v0(150)]", object: imagelogin)
        autolayoutonecontraints(view: view, text: "H:[v0(150)]", object: imagelogin)
        imagelogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //createimage
    func imagecreate(){
        imagelogin.image = UIImage(named: "register")
        imagelogin.contentMode = .scaleAspectFill
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleselectimage))
        imagelogin.isUserInteractionEnabled = true
        imagelogin.addGestureRecognizer(tap)
        imagelogin.skin()
        view.addSubview(imagelogin)
    }
    
    //handle handleselectimage
    @objc func handleselectimage(){
        let alert: UIAlertController = UIAlertController(title: "Thông báo", message: "Vui long chọn dịch vụ", preferredStyle: .alert)
        let btphoto: UIAlertAction = UIAlertAction(title: "Photo", style: .default) { (btphoto) in
            self.selectimage(type: .photoLibrary)
        }
        let btcamera: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (btcamera) in
            self.selectimage(type: .camera)
        }
        let btcancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(btphoto)
        alert.addAction(btcamera)
        alert.addAction(btcancel)
        present(alert, animated: true, completion: nil)
    }
    
    //creeate func select image
    func selectimage(type: UIImagePickerController.SourceType){
        let imagepicker: UIImagePickerController = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.sourceType = type
        imagepicker.allowsEditing = true
        self.present(imagepicker, animated: true, completion: nil)
    }
    
    //create autolayout txtpass separator
    func txtpassautolayout(){
        txtpasscreate()
        txtpass.translatesAutoresizingMaskIntoConstraints = false
        let height = heightuicontainview / 3
        autolayoutonecontraints(view: uicontainview, text: "V:[v0(\(height))]|", object: txtpass)
        autolayoutonecontraints(view: uicontainview, text: "H:|-12-[v0]|", object: txtpass)
    }
    
    //create txtpass
    func txtpasscreate(){
        txtpass.placeholder = "input password"
        txtpass.isSecureTextEntry = true
        uicontainview.addSubview(txtpass)
    }
    
    //autolayout passs separator
    func passseparatorautolayout(){
        createpassseparator()
        passseparator.translatesAutoresizingMaskIntoConstraints = false
        let height = heightuicontainview / 3
        autolayoutonecontraints(view: uicontainview, text: "V:[v0(\(height))]|", object: passseparator)
        autolayoutonecontraints(view: uicontainview, text: "H:|[v0]|", object: passseparator)
        txtpassautolayout()
    }
    
    //khởi tạo txtpass
    func createpassseparator(){
        passseparator.backgroundColor = .white
        passseparator.layer.borderWidth = 0.5
        passseparator.layer.borderColor = UIColor(r: 61, g: 91, b: 151).cgColor
        uicontainview.addSubview(passseparator)
        
    }
    
    //autolayout txtemail
    func autolayouttxtemail(){
        createtxtemail()
        txtemail.translatesAutoresizingMaskIntoConstraints = false
        let height = heightuicontainview / 3
        autolayoutonecontraints(view: uicontainview, text: "V:|-\(height)-[v0(\(height))]", object: txtemail)
        autolayoutonecontraints(view: uicontainview, text: "H:|-12-[v0]|", object: txtemail)
    }
    
    //khơi tạo txtemail
    func createtxtemail(){
        txtemail.placeholder = "input email"
        txtemail.keyboardType = .emailAddress
        uicontainview.addSubview(txtemail)
    }
    
    //autolayout email separator
    func autolayoutemailseparator(){
        createemailseparator()
        emailseparator.translatesAutoresizingMaskIntoConstraints = false
        let height = heightuicontainview / 3
        autolayoutonecontraints(view: uicontainview, text: "V:|-\(height)-[v0(\(height))]", object: emailseparator)
        autolayoutonecontraints(view: uicontainview, text: "H:|[v0]|", object: emailseparator)
        autolayouttxtemail()
    }
    
    //khởi tạo separator email
    func createemailseparator(){
        emailseparator.backgroundColor = UIColor.white
         emailseparator.layer.borderColor = UIColor(r: 61, g: 91, b: 151).cgColor
        emailseparator.layer.borderWidth = 0.5
        uicontainview.addSubview(emailseparator)
    }
    
    //autolayout name separator
    func autuolayoutseparator(){
        createseparatorname()
        nameseparator.translatesAutoresizingMaskIntoConstraints = false
        let height = heightuicontainview / 3
        autolayoutonecontraints(view: uicontainview, text: "V:|[v0(\(height))]", object: nameseparator)
        autolayoutonecontraints(view: uicontainview, text: "H:|[v0]|", object: nameseparator)
    }
    
    //khỏi tạo dãy phân cách
    func createseparatorname(){
        nameseparator.backgroundColor = UIColor.white
        nameseparator.layer.borderWidth = 0.5
        nameseparator.layer.borderColor = UIColor(r: 61, g: 91, b: 151).cgColor
        nameseparator.tag = 10
        
        uicontainview.addSubview(nameseparator)
    }
    //khởi tạo biến height cho name
    var heightname: NSLayoutConstraint?
    //Autolayout txtname
    func autolayouttxtname(){
        createtxtname()
        txtname.translatesAutoresizingMaskIntoConstraints = false
        let height = heightuicontainview / 3
        txtname.leftAnchor.constraint(equalTo: uicontainview.leftAnchor, constant: 12).isActive = true
        txtname.topAnchor.constraint(equalTo: uicontainview.topAnchor).isActive = true
        txtname.widthAnchor.constraint(equalTo: uicontainview.widthAnchor).isActive = true
        heightname = txtname.heightAnchor.constraint(equalToConstant: height)
        heightname?.isActive = true
//        autolayoutonecontraints(view: uicontainview, text: "V:|[v0]", object: txtname)
//        autolayoutonecontraints(view: uicontainview, text: "H:|-12-[v0]|", object: txtname)
    }
    //khởi tạo txtname
    func createtxtname(){
        txtname.placeholder = "input name"
        self.uicontainview.addSubview(txtname)
    }
    //khởi tạo button register
    func createbuttonregister(){
        buttonRegister = UIButton(type: .system)
        buttonRegister.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.setTitleColor(UIColor.white, for: .normal)
        buttonRegister.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonRegister.layer.cornerRadius = 5
        buttonRegister.clipsToBounds = true
        buttonRegister.addTarget(self, action: #selector(handleregister), for: .touchUpInside)
        self.view.addSubview(buttonRegister)
    }
    //xử lý khi user nhấn button Register
    @objc func handleregister(){
        //tạo email & pass trên Auth
        guard let email = txtemail.text, let pass = txtpass.text, let name = txtname.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: pass) { (resutl, err) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
            }
            else {
                //kiểm tra uic
                guard (resutl?.user.uid) != nil else {
                    return
                }
                //thêm dữ liệu cho child: User
//                let current = Auth.auth().currentUser
//                self.movescreenbynavi(text: "messagecontroller")
//                    child.setValue(user)
                //tạo folder & upload iamge lên folder trên firebase
                //đổi image thành data
//                let imagedata = self.imagelogin.image?.pngData()
                //tạo folder trên Storage
                let path = storage.child("Image_Avatar:/\(self.txtemail.text!).jpg")
                //upload hình lên Storage
                path.putData(self.imagedata!, metadata: nil) { (metadata, err) in
                    if err != nil {
                        print(err?.localizedDescription ?? "hihi")
                    }
                    else {
                        path.downloadURL(completion: { (url, err) in
                            if err != nil {
                                print(err?.localizedDescription ?? "hihi")
                            }
                            else {
                                self.dowload_url = url?.absoluteString
                                let user = ["email": email, "pass": pass, "name": name, "Avtar_url": self.dowload_url]
                                let tableuser = ref.child("user").child((resutl?.user.uid)!)
                                tableuser.setValue(user)
                            }
                        })

                    }}}}
    }


    var heightuicontain: NSLayoutConstraint?
    func autolayoutcontainview(){
        createbuttonregister()
        uicontainview.translatesAutoresizingMaskIntoConstraints = false
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        //khoảng cách từ top >>>
        let distancetoview = self.view.frame.size.height / 2 - 75
        autolayouttwocontraints(view: view, text: "V:|-\(distancetoview)-[v0]-12-[v1(30)]", object1: uicontainview, object2: buttonRegister)
        heightuicontain =  uicontainview.heightAnchor.constraint(equalToConstant: heightuicontainview)
        heightuicontain?.isActive = true
        autolayoutonecontraints(view: view, text: "H:|-12-[v0]-12-|", object: uicontainview)
        autolayoutonecontraints(view: view, text: "H:|-12-[v0]-12-|", object: buttonRegister)
        //Chỉ 1 layout: uicontainview
        //        autolayoutonecontraints(text: "V:|-\(distancetoview)-[v0(150)]", object: uicontainview)
        //chỉ 1 layout: btregister
        //        autolayoutonecontraints(text: "V:|[v0]|", object: buttonRegister)
    }


    
    //light Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
//extion by thí, để app có thể chọn
extension register:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chooseiamge = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imagevalue = max(chooseiamge.size.width, chooseiamge.size.height)
        if imagevalue > 3000 {
            self.imagedata = chooseiamge.jpegData(compressionQuality: 0.3)
        }
        else if imagevalue > 2000 {
            self.imagedata = chooseiamge.jpegData(compressionQuality: 0.1)
        }
        else {
            self.imagedata = chooseiamge.pngData()
        }
        imagelogin.image = UIImage(data: imagedata)
        
        
        dismiss(animated: true, completion: nil)
    }
    
}

