//
//  Genre.swift
//  MovieTranslator
//
//  Created by Никита on 12.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import ObjectMapper

class GenreList : BaseModel {
    
    var list: [[String : Any]]?
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)

        self.list           <- map["genres"]
    }
    
    
    
    
//    init(list: Dictionary<String, String>) {
//        self.list = list
//    }
//    var id : Int?
//    var name : String?
//    
//    public required init?(map: Map) {
//        super.init(map: map)
//    }
//    
//    public override func mapping(map: Map) {
//        super.mapping(map: map)
//        
//         self.name           <- map["genre"]
//        
//        
//    }
    
    
}


