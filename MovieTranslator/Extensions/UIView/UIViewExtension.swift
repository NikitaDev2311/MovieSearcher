//
//  UIViewExtension.swift
//  MovieTranslator
//
//  Created by Никита on 06.03.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func frameBottom() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
    
}
