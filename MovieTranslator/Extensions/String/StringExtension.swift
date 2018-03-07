//
//  StringExtension.swift
//  MovieTranslator
//
//  Created by Никита on 07.03.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation

extension String {
    func firstCharIsWhiteSpace() -> Bool {
        if self.first == whiteSpace {
            return true
        }
        return false
    }
    
    func isWhiteSpace() -> Bool {
        if self == " " {
            return true
        }
        return false
    }
}
