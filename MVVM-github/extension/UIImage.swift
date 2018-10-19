//
//  UIImage.swift
//  MVVM-github
//
//  Created by 中川万莉奈 on 2018/10/07.
//  Copyright © 2018年 中川万莉奈. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(color: UIColor, size:CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
