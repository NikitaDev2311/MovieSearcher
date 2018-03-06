//
//  Extension.swift
//  MovieTranslator
//
//  Created by Никита on 12.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

extension UIImageView {
    
    func setImage(withImageURL imageURL : String?) {
        if let imageUrl = imageURL {
            self.sd_setImage(with: URL(string: imageUrl) , placeholderImage: #imageLiteral(resourceName: "noimage"), options: .continueInBackground, completed: nil)
        }
    }
    
}

