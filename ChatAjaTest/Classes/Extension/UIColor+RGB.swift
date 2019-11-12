//
//  UIColor+RGB.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 08/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static var primary: UIColor {
      return UIColor(red: 1 / 255, green: 93 / 255, blue: 48 / 255, alpha: 1)
    }
    
    static var incomingMessage: UIColor {
      return UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }
}
