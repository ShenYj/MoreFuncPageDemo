//
//  HeaderView.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

class HeaderView: UIView {
    
    static func loadHeaderView() -> HeaderView {
        guard let xib = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.last as? HeaderView else {
            return HeaderView()
        }
        return xib
    }
}
