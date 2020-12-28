//
//  MoreFuncController.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit
import RxSwift

internal class MoreFuncController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var functionsView: MoreFuncScrollView = {
        let functionView = MoreFuncScrollView(frame: CGRect(x: 0, y: navigationTotalHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - navigationTotalHeight))
        functionView.moreFuncDelegate = self
        return functionView
    }()
    
    private lazy var editButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        btn.setTitle("编辑", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.yellow, for: .highlighted)
        btn.rx.tap.subscribe { [weak self] (onNext) in self?.targetForEdit(sender: btn) }.disposed(by: disposeBag)
        return btn
    }()
    
    private lazy var backOrCancelButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitleColor(.yellow, for: .highlighted)
        btn.rx.tap.subscribe { [weak self] (onNext) in self?.targetForGobackOrCancel(sender: btn) }.disposed(by: disposeBag)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backOrCancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    
    @objc private func targetForEdit(sender: UIButton) {
        functionsView.changeEditStatus(isEditing: !functionsView.isEdit)
        updateEditButton(isEditing: functionsView.isEdit)
    }
    
    private func updateEditButton(isEditing: Bool) {
        
        if isEditing {
            editButton.setTitle("完成", for: .normal)
        } else {
            editButton.setTitle("编辑", for: .normal)
        }
    }
    
    @objc private func targetForGobackOrCancel(sender: UIButton) {
        if functionsView.isEdit {
            functionsView.changeEditStatus(isEditing: !functionsView.isEdit, reset: true)
            
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateBackOrCancelButton(isEditing: Bool) {
        
        if isEditing {
            backOrCancelButton.setTitle("取消", for: .normal)
        } else {
            backOrCancelButton.setTitle("返回", for: .normal)
        }
    }
}

extension MoreFuncController: MoreFuncProtocol {
    
    func moreFuncView(_ moreFuncView: MoreFuncScrollView, inEditStatus isEditing: Bool) {
        updateEditButton(isEditing: isEditing)
        updateBackOrCancelButton(isEditing: isEditing)
    }
}
