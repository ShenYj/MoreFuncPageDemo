//
//  FunctionsModel.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import Foundation
import Dollar
import ObjectMapper

struct FunctionsModel: Mappable {
    
    var version: Int = 0
    var `default`: [Int] = []
    var data: [GroupFunctionModel] = []
    
    init?(map: Map) {  }
    
    mutating func mapping(map: Map) {
        `default`  <- map["default"]
        version    <- map["version"]
        data       <- map["data"]
    }
}

extension FunctionsModel {
    
    var allFunctions: [FunctionModel] { data.flatMap { Dollar.copy($0.groupData) } }
    
    /// 已选功能
    var defaultSelectedFunctions: [FunctionModel] { Dollar.remove(allFunctions, callback: { !self.default.contains($0.functionId) }) }
    
    /// 可选
    mutating func optionalGroupFunctions(selectedFuncs: [FunctionModel]) -> [GroupFunctionModel] {
        
        var newGroups: [GroupFunctionModel] = []
        Dollar.each(data, callback: {
            let groupFuncs = Dollar.difference($0.groupData, selectedFuncs)
            var group = $0.copy() as! GroupFunctionModel
            group.groupData = groupFuncs
            newGroups.append(group)
        })
        return newGroups
    }
}
