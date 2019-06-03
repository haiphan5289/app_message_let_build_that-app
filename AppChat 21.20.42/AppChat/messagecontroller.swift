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
    var mangtemp = ["A", "B"]
    let naviitem: UINavigationItem = UINavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
//        setupnavibarcustom()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handlelogout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new"), style: .plain, target: self, action: #selector(handlemovetonewmesssage))
        //kiểm tra user có đăng nhập không
        checkuser_inputtitle()
        
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
                let user: User = User(email: email ?? "emaildemo", name: name ?? "loading....", pass: pass ?? "passdemo", link_image: link ?? "linkdemo" )
//                self.navigationItem.title = user.name
                self.setupnavigationitem(user: user)
            }
        }
    }
    func setupnavigationitem(user: User){
        //Tạo view cho title
        let titleview = UIView()
        //nên set-up width là  
        titleview.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        titleview.backgroundColor = .red
        titleview.alpha = 1
        
        //tạo image kế bên title
        let image : UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.load_image(text: user.link_image!, positionx: 0, positiony: 0)
        titleview.addSubview(image)
        //add contraints cho image
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
        
        
        self.navigationItem.titleView = titleview
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
        return mangtemp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! cell
        cell.textLabel?.text = mangtemp[indexPath.row]
        return cell
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

