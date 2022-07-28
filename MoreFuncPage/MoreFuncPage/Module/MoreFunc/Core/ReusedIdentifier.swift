//
//  MoreFuncCellInfo.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import Foundation

enum ReusedIdentifier: String {
    
    case undefine   = "ReusedIdentifier.undefine"
    case normal     = "ReusedIdentifier.normal"
    case add        = "ReusedIdentifier.add"
    case remove     = "ReusedIdentifier.remove"
    case more       = "ReusedIdentifier.more"
    
    enum SupplementaryElement: String {
        case selectedHeader = "ReusedIdentifier.SupplementaryElement.selectedHeader"
        case selectedFooter = "ReusedIdentifier.SupplementaryElement.selectedFooter"
        case optionalHeader = "ReusedIdentifier.SupplementaryElement.optionalHeader"
        case optionalFooter = "ReusedIdentifier.SupplementaryElement.optionalFooter"
    }
}
