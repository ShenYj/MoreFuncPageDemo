//
//  FunctionModel.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import Foundation
import ObjectMapper

struct FunctionModel: Mappable {
    
    var functionId: Int = 0
    var icon: String = ""
    var functionName: String = ""
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        functionId          <- map["functionId"]
        icon                <- map["icon"]
        functionName        <- map["functionName"]
    }
    
}

extension FunctionModel: Equatable {
    
    static func == (lhs: FunctionModel, rhs: FunctionModel) -> Bool {
        lhs.functionId == rhs.functionId
    }
}

extension FunctionModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(functionId)
    }
}
