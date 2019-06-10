//
//  viewui.swift
//  AppChat
//
//  Created by HaiPhan on 5/31/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import UIKit

//Tăng speed load image
let image_Cache = NSCache<AnyObject, AnyObject>()

extension UIColor {
    //thu gọn UIColor
    convenience  init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
extension UIImageView{
    func skin(){
        self.layer.cornerRadius = 75
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 2
        self.clipsToBounds = true
    }
    func load_image(text: String, positionx: CGFloat, positiony: CGFloat){
        //check cache for image first
        //Hiện thi image ngay lập tức
        if let imageCache = image_Cache.object(forKey: text as AnyObject) {
            self.image = imageCache as! UIImage
            //return là khi nó chạy xong hàm này là dừng hẳn luôn.
            return
        }
        let activities: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activities.frame = CGRect(x: positionx , y: positiony, width: 0, height: 0)
        activities.color = .blue
        activities.hidesWhenStopped = true
        activities.startAnimating()
        self.addSubview(activities)
        let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.async {
            let url = URL(string: text)
            let data = try? Data(contentsOf: url!)
            let imagedefault = UIImage(named: "login")?.pngData()
            queue.sync {
                if let image_dowload = UIImage(data: data ?? imagedefault! ) {
                    activities.stopAnimating()
                    //tăng speed load iamge
                    image_Cache.setObject(image_dowload, forKey: text as AnyObject)
                    self.image = image_dowload
                }

            }

        }

    }
}
