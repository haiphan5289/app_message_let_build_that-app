//
//  loginreal.swift
//  AppChat
//
//  Created by HaiPhan on 5/31/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase

class login: UIViewController {
    
    var viewui: UIView! = UIView()
    var emailseparator: UIView = UIView()
    var txtemail: UITextField = UITextField()
    var passseparator: UIView = UIView()
    var txtpass: UITextField = UITextField()
    var buttonlogin: UIButton = UIButton()
    var imagelogin: UIImageView! = UIImageView()
    var buttonregister: UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  UIColor(r: 61, g: 91, b: 151)
        implementcode()
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(nothing))
        
    }

    override func viewWillAppear(_ animated: Bool) {
//        logoutaccount()
        islogined()
    }
    //selector
    @objc func nothing(){
        print("hihi")
    }
    
    //kiểm tra tải khoản có đang signin không
    //Sau khi login sẽ check lại lần nữa, và tự động move
    func islogined(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.movescreenbynavi(text: "messagecontroller")
            }}}
    
    //check tài khảon
    func logoutaccount(){
        do {
            try Auth.auth().signOut()
        }catch let error as NSError {
            print(error)
        }
    }
    
    //thực thi
    func implementcode(){
        viewuiautolayout()
        emailseparatorautolayout()
        txtemailautolayout()
        passseparatorautolayout()
        txtpassautolayout()
        btloginautolayout()
        imageautolayout()
        btregisterautolayout()
        
    }
    
    
    func btregisterautolayout(){
        buttonregistercreate()
        buttonregister.translatesAutoresizingMaskIntoConstraints = false
        buttonregister.topAnchor.constraint(equalTo: buttonlogin.bottomAnchor, constant: 12).isActive = true
        autolayoutonecontraints(view: view, text: "H:|-12-[v0]-12-|", object: buttonregister)
        autolayoutonecontraints(view: view, text: "V:[v0(30)]", object: buttonregister)
    }
    
    //khởi tạo button login
    func buttonregistercreate(){
        buttonregister = UIButton(type: .system)
        buttonregister.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        buttonregister.setTitle("Register", for: .normal)
        buttonregister.setTitleColor(UIColor.white, for: .normal)
        buttonregister.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonregister.layer.cornerRadius = 5
        buttonregister.clipsToBounds = true
        buttonregister.addTarget(self, action: #selector(movetoregister), for: .touchUpInside)
        view.addSubview(buttonregister)
    }
    
    //move to register
    @objc func movetoregister(){
        self.movescreenbynavi(text: "register")
    }
    
    
    
    func imageautolayout(){
        imagecreate()
        imagelogin.translatesAutoresizingMaskIntoConstraints = false
        imagelogin.bottomAnchor.constraint(equalTo: viewui.topAnchor, constant: -52).isActive = true
        autolayoutonecontraints(view: view, text: "V:[v0(150)]", object: imagelogin)
        autolayoutonecontraints(view: view, text: "H:[v0(150)]", object: imagelogin)
        imagelogin.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //createimage
    func imagecreate(){
        imagelogin.image = UIImage(named: "login")
        imagelogin.contentMode = .scaleAspectFill
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleselectimage))
        //        imagelogin.isUserInteractionEnabled = true
        //        imagelogin.addGestureRecognizer(tap)
        imagelogin.skin()
        view.addSubview(imagelogin)
    }
    
    
    //autolayout button login
    func btloginautolayout(){
        buttonlogincreate()
        buttonlogin.translatesAutoresizingMaskIntoConstraints = false
        buttonlogin.topAnchor.constraint(equalTo: viewui.bottomAnchor, constant: 12).isActive = true
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
        guard let email = txtemail.text, let pass = txtpass.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: pass) { (user, err) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
                return
            }
//            else{
////                let new = messagecontroller()
////                let navi = UINavigationController(rootViewController: new)
////                self.present(navi, animated: true, completion: nil)
////                self.dismiss(animated: true, completion: nil)
////                self.movescreenbynavi(text: "messagecontroller")
//
//            }
        }
    }
    
    func txtpassautolayout(){
        txtpasscreate()
        txtpass.translatesAutoresizingMaskIntoConstraints = false
        autolayoutonecontraints(view: viewui, text: "V:[v0(50)]|", object: txtpass)
        autolayoutonecontraints(view: viewui, text: "H:|-12-[v0]|", object: txtpass)
    }
    
    //taok txtfield
    func txtpasscreate(){
        txtpass.placeholder = "input pass"
        viewui.addSubview(txtpass)
    }
    
    
    func passseparatorautolayout(){
        passseparatorcreate()
        passseparator.translatesAutoresizingMaskIntoConstraints = false
        autolayoutonecontraints(view: viewui, text: "V:[v0(50)]|", object: passseparator)
        autolayoutonecontraints(view: viewui, text: "H:|[v0]|", object: passseparator)
    }
    
    //tạo separator email
    func passseparatorcreate(){
        passseparator.backgroundColor = .white
        passseparator.layer.borderWidth = 0.5
        passseparator.layer.borderColor = UIColor(r: 61, g: 91, b: 151).cgColor
        viewui.addSubview(passseparator)
    }
    
    
    
    func txtemailautolayout(){
        txtemailcreate()
        txtemail.translatesAutoresizingMaskIntoConstraints = false
        autolayoutonecontraints(view: viewui, text: "V:|[v0(50)]", object: txtemail)
        autolayoutonecontraints(view: viewui, text: "H:|-12-[v0]|", object: txtemail)
    }
    
    //taok txtfield
    func txtemailcreate(){
        txtemail.placeholder = "input email"
        viewui.addSubview(txtemail)
    }
    
    //autolayout cho separtor
    func emailseparatorautolayout(){
        emailseparatorcreate()
        emailseparator.translatesAutoresizingMaskIntoConstraints = false
        autolayoutonecontraints(view: viewui, text: "V:|[v0(50)]", object: emailseparator)
        autolayoutonecontraints(view: viewui, text: "H:|[v0]|", object: emailseparator)
    }
    
    //tạo separator email
    func emailseparatorcreate(){
        emailseparator.backgroundColor = .white
        emailseparator.layer.borderWidth = 0.5
        emailseparator.layer.borderColor = UIColor(r: 61, g: 91, b: 151).cgColor
        viewui.addSubview(emailseparator)
    }
    
    //autolayout
    func viewuiautolayout(){
        viewcreate()
        viewui.translatesAutoresizingMaskIntoConstraints = false
        let height = self.view.frame.size.height / 2 - 50
        autolayoutonecontraints(view: view, text: "V:|-\(height)-[v0(100)]|", object: viewui)
        autolayoutonecontraints(view: view, text: "H:|-12-[v0]-12-|", object: viewui)
    }
    
    //tạo view
    func viewcreate(){
        viewui.backgroundColor = .white
        view.addSubview(viewui)
    }
    
}
