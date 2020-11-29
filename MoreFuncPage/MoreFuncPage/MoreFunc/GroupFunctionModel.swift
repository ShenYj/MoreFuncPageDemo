//
//  GroupFunctionModel.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import Foundation
import SwiftyJSON
import ObjectMapper

struct GroupFunctionModel: Mappable {
    
    var groupId: Int = 0
    var groupTitle: String = ""
    var groupData: [FunctionModel] = []
    
    init?(map: Map) {  }
    
    mutating func mapping(map: Map) {
        groupId     <- map["groupId"]
        groupTitle  <- map["groupTitle"]
        groupData   <- map["groupData"]
    }
}

extension GroupFunctionModel: Equatable {
    
    static func == (lhs: GroupFunctionModel, rhs: GroupFunctionModel) -> Bool {
        lhs.groupId == rhs.groupId
    }
}

extension GroupFunctionModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(groupId)
    }
}

extension GroupFunctionModel: Copyable {
    
    func copy() -> Copyable {
        GroupFunctionModel.init(JSON: self.toJSON())!
    }
}
