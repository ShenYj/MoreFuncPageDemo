//
//  ViewController.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    /// 更多功能
    @IBOutlet weak var moreFuncButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moreFuncButton.rx.tap.subscribe { [weak self] (onNext) in self?.navigationController?.pushViewController(MoreFuncController(), animated: true) }.disposed(by: disposeBag)
        
    }
    
}

