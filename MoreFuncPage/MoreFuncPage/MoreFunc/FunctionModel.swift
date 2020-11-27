//
//  FunctionModel.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import Foundation
import ObjectMapper

class FunctionModel: Mappable {
    
    var functionId: Int = 0
    var icon: String = ""
    var functionName: String = ""
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        functionId          <- map["functionId"]
        icon                <- map["icon"]
        functionName        <- map["functionName"]
    }
    
}
