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
    
    private lazy var editButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        btn.setTitle("编辑", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.yellow, for: .highlighted)
        btn.addTarget(self, action: #selector(targetForEdit(sender:)), for: .touchUpInside)
        return btn
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    
    @objc private func targetForEdit(sender: UIBarButtonItem) {
        functionsView.isEdit = !functionsView.isEdit
        if functionsView.isEdit {
            editButton.setTitle("完成", for: .normal)
        } else {
            editButton.setTitle("编辑", for: .normal)
        }
    }
}


