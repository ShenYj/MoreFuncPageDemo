//
//  GroupFunctionModel.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import Foundation
import ObjectMapper

class GroupFunctionModel: Mappable {
    
    var groupId: Int = 0
    var groupTitle: String = ""
    var groupData: [FunctionModel] = []
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        groupId     <- map["groupId"]
        groupTitle  <- map["groupTitle"]
        groupData   <- map["groupData"]
    }
}
