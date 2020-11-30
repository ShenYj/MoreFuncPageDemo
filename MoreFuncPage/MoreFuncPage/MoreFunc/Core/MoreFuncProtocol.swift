//
//  MoreFuncProtocol.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/30.
//

import Foundation

/// 感受一下Swift下实现optional协议的方式, 非必要, 默认必须实现
@objc protocol MoreFuncProtocol: NSObjectProtocol {
    
    @objc optional func moreFuncView(_ moreFuncView: MoreFuncScrollView, inEditStatus isEditing: Bool) -> Void
}
