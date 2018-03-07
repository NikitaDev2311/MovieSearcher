//
//  UIViewControllerExtension.swift
//  MovieTranslator
//
//  Created by Никита on 06.03.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    func showLoading() {
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.show()
    }
    
    @objc func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showAlert(withMessage message: String, actionOK: UIAlertAction?) {
        
        let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        var action = UIAlertAction()
        guard let okAction = actionOK else {
            action = UIAlertAction(title: okTitle, style: .cancel, handler: nil)
            return
        }
        action = okAction
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNetworkingAlert(withAction action: UIAlertAction) {
        showAlert(withMessage: networkMessage, actionOK: action)
    }
}
