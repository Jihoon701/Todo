//
//  UITextField.swift
//  Todo
//
//  Created by 김지훈 on 2022/04/13.
//

import Foundation
import UIKit

extension UITextField {
    func setupLeftImage(imageName:String) {
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.height * 0.7, height: self.frame.height))
        let imageSize = 18
        let imageView = UIImageView(frame: CGRect(x: Int(imageContainerView.center.x) - imageSize/2 + 3, y: Int(imageContainerView.center.y) - imageSize/2, width: imageSize, height: imageSize))
        
        imageView.image = UIImage(named: imageName)
        imageContainerView.addSubview(imageView)
        leftView = imageContainerView
//        leftView?.backgroundColor = .red
        leftViewMode = .always
        self.tintColor = .gray
    }
}
