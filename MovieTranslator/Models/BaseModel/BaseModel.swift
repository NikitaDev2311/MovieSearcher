//
//  BaseModel.swift
//  MovieTranslator
//
//  Created by Никита on 12.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: Mappable {

    public var modelID = 0
    
    public required init?(map: Map) {
    }
    
    init(modelID: Int) {
        self.modelID = modelID
    }
    
    public func mapping(map: Map) {
        self.modelID <- map["id"]
    }
    
}
