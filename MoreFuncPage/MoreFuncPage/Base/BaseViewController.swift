//
//  BaseViewController.swift
//  
//
//  Created by ShenYj on 2021/07/13.
//
//  Copyright (c) 2021 ShenYj <shenyanjie123@foxmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import RxSwift
import RxCocoa
import RxSwiftExt
import RxOptional
import RxViewController
import UIKit

class BaseViewController: UIViewController, ViewType {
    
    var viewModel: BaseViewModel?
    
    /// 构造方法
    init(viewModel: BaseViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 类名
    public lazy private(set) var className: String = { type(of: self).description().components(separatedBy: ".").last ?? "" }()

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if DEBUG
        print("当前控制器: \(#function) \(self.className)")
        #endif
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        #if DEBUG
        print("当前控制器: \(#function) \(self.className)")
        #endif
    }
    
    deinit {
        #if DEBUG//RXSWIFT TRACE_RESOURCES
        print("当前控制器: DEINIT: \(self.className)")
        #endif
    }
}


extension BaseViewController {
    
    /// 设置UI
    ///
    /// - Note: 在`viewDidLoad`中被调用
    ///
    @objc public func setupUI() {
        view.backgroundColor = .white
        view.clipsToBounds = true
    }
    
    /// 更新UI
    ///
    /// - Note: 在`viewDidLoad`中被调用
    ///
    @objc public func updateUI() {
        view.setNeedsDisplay()
    }
    
    /// 绑定`viewModel`
    ///
    /// - Note: 在`viewDidLoad`中被调用
    /// - Note: 在`setupUI`之后被调用
    ///
    @objc public func bindViewModel() {
        fatalError(" \(self.className) 未重写 bindViewModel ")
    }
}

