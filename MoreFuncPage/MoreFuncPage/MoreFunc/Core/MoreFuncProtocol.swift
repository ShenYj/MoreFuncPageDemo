//
//  MoreFuncProtocol.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/30.
//

import Foundation

protocol MoreFuncProtocol: NSObjectProtocol {
    
    func moreFuncView(_ moreFuncView: MoreFuncScrollView, inEditStatus isEditing: Bool) -> Void
}
