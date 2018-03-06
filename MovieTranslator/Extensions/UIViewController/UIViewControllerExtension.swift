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
    
    func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
