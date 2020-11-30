//
//  ViewController+Ex.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: 状态栏高度
    final var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIApplication
                .appKeyWindow()?
                .windowScene?
                .statusBarManager?
                .statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    // MARK: 导航栏高度
    final var navigationBarHeight: CGFloat { self.navigationController?.navigationBar.frame.height ?? 0 }
    
    // MARK: 导航栏+状态栏整体高度
    final var navigationTotalHeight: CGFloat { statusBarHeight + navigationBarHeight }
}
