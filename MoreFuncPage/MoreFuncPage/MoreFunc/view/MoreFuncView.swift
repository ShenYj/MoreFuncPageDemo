//
//  MoreFuncView.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/27.
//

import UIKit

class MoreFuncView: UIView {
    
    @IBOutlet weak var moreFunctionsLabel: UILabel!
    
    static func loadMoreFuncView() -> MoreFuncView {
        guard let xib = Bundle.main.loadNibNamed("MoreFuncView", owner: nil, options: nil)?.last as? MoreFuncView else {
            return MoreFuncView()
        }
        return xib
    }
}
