//
//  ResponseParser.swift
//  MovieTranslator
//
//  Created by Никита on 11.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ResponseParser {
    
    class func parseToDataArray(_ fromResponse: DataResponse<Any>?) -> [[String : Any]]? {
        let jsonArray = JSON(fromResponse?.result.value! as Any)
        return jsonArray["results"].arrayObject as? [[String : Any]]
    }
    
    class func parseToDataObject(_ fromResponse: DataResponse<Any>?) -> [String : Any]? {
        let jsonData = JSON(fromResponse?.result.value! as Any)
        return jsonData.dictionaryObject
    }
    
}
