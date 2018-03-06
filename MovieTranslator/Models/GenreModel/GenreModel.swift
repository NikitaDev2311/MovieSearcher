//
//  GenreModel.swift
//  MovieTranslator
//
//  Created by Никита on 13.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import ObjectMapper

class GenreModel {
    
    var id : Int?
    var name : String?
    
//    public required init?(map: Map) {
//        super.init(map: map)
//    }
//
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//
//        self.id             <- map["id"]
//        self.name           <- map["name"]
//    }
    
    init(withID id: Int, _ name: String) {
        self.id = id
        self.name = name
    }
    
    
}


class GenreList : BaseModel {
    
    var list: [[String : Any]]?
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.list           <- map["genres"]
    }
}
