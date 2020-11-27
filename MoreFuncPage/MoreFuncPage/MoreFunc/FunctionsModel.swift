//
//  FunctionsModel.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import Foundation
import ObjectMapper

class FunctionsModel: Mappable {
    
    var version: Int = 0
    var `default`: [Int] = []
    var data: [GroupFunctionModel] = []
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        `default`  <- map["default"]
        version    <- map["version"]
        data       <- map["data"]
    }
}

extension FunctionsModel {
    
    var allFunctions: [FunctionModel] {
        get {
            if self.default.isEmpty { return [] }
            return self.data.flatMap { $0.groupData }
        }
    }
    
    var selectedFunctions: [FunctionModel] { allFunctions.filter{ self.default.contains($0.functionId) } }
    
    var optionalFunctions: [FunctionModel] { allFunctions.filter{ !self.default.contains($0.functionId) } }
}
