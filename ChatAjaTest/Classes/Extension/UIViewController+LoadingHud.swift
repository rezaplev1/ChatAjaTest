//
//  UIViewController+LoadingHud.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 08/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    func showLoadingHUD(_ loadingText : String? = nil) {
        SVProgressHUD.show(withStatus: loadingText)
    }
    
    func hideLoadingHUD() {
        SVProgressHUD.dismiss()
    }
    
    func showSuccessHUD(_ message : String? = nil) {
        SVProgressHUD.showSuccess(withStatus: message)
    }
}
