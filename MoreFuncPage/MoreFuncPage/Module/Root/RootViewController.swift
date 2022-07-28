//
//  ViewController.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxOptional
import RxSwiftExt
import NSObject_Rx

class RootViewController: BaseViewController {
    
    /// 更多功能
    private lazy var moreFuncButton = UIButton()
        .then{
            $0.setImage(UIImage(systemName: "aqi.medium"), for: .normal)
        }
    
}

extension RootViewController {
    
    override func bindViewModel() {
        
        guard let viewModel = viewModel as? RootViewModel else { return }
        
        let pushMoreFuncPage = moreFuncButton.rx.tap.mapTo(())
        
        let input = RootViewModel.Input(
            pushMoreFuncPage: pushMoreFuncPage
        )
        let output = viewModel.transform(input: input)
        
        output.pushMoreFuncPage.bind(to: rx.pushMoreFuncPage).disposed(by: rx.disposeBag)
    }
}

extension RootViewController {
    
    override func setupUI() {
        super.setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreFuncButton)
    }
}

extension Reactive where Base: RootViewController {
    
    var pushMoreFuncPage: Binder<Void> {
        Binder(base) { owner, _ in
            owner.navigationController?.pushViewController(MoreFuncController(), animated: true)
        }
    }
}
