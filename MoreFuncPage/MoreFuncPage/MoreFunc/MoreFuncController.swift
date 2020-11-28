//
//  MoreFuncController.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

internal class MoreFuncController: UIViewController {
    
    private lazy var functionsView: MoreFuncScrollView = {
        let functionView = MoreFuncScrollView(frame: CGRect(x: 0, y: navigationTotalHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - navigationTotalHeight))
        return functionView
    }()
}

extension MoreFuncController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        title = "更多"
        view.backgroundColor = .white
        view.addSubview(functionsView)
    }
}


