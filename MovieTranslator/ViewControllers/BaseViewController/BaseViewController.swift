//
//  BaseViewController.swift
//  MovieTranslator
//
//  Created by Никита on 28.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - lazy init -
    
    lazy var router : Router = {
        Router(self.navigationController)
    }()
    
    //MARK: - Protected -
    
    func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}
