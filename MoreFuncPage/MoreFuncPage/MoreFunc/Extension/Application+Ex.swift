//
//  Application+Ex.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

extension UIApplication {
    
    internal static func appKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            guard UIApplication.shared.connectedScenes.count > 0 else {
                return UIApplication.shared.delegate?.window ?? nil
            }
            if let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first  {
                return keyWindow
            }
            return UIApplication.shared.delegate?.window ?? nil
        }
        return UIApplication.shared.keyWindow
    }
}
