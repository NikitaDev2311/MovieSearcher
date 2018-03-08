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
    
    func openDeviseSettings() {
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func showAlert(withMessage message: String, actionOK: UIAlertAction?, completion: (() -> Void)?) {
        guard let completionBlock = completion else {return}
        let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        var action = UIAlertAction()
        let settingsAction = UIAlertAction(title: settingsTitle, style: .default) { (action) in
            self.openDeviseSettings()
            completionBlock()
        }
        guard let okAction = actionOK else {
            action = UIAlertAction(title: okTitle, style: .cancel, handler: nil)
            return
        }
        action = okAction
        alert.addAction(action)
        alert.addAction(settingsAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNetworkingAlert(withAction action: UIAlertAction?, completion: (() -> Void)?) {
        showAlert(withMessage: networkMessage, actionOK: action, completion: completion)
    }
}
