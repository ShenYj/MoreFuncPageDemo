//
//  Application+Ex.swift
//  MoreFuncPage
//
//  Created by ShenYj on 2020/11/26.
//

import UIKit

extension UIApplication {
    
    internal static func appKeyWindow() -> UIWindow? {
        guard UIApplication.shared.connectedScenes.isEmpty == false else {
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
}
