//
//  FunctionManager.swift
//  Pods
//
//  Created by ShenYj on 2020/11/27.
//

import Foundation
import SwiftyJSON

class FunctionManager {
    
    static let shared: FunctionManager = FunctionManager()
    
    var functionConfig: FunctionsModel?
    
}


extension FunctionManager {
    
    static func loadLocalFuncs(callback: @escaping (_ config: FunctionsModel?) -> Void ) {
        
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: "default_function", ofType: "json") else {
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let json = try JSON(data: data)
                
                guard let funcConfig = FunctionsModel(JSON: json.dictionaryObject ?? [:]) else {
                    DispatchQueue.main.async {
                        callback(nil)
                    }
                    return
                }
                FunctionManager.shared.functionConfig = funcConfig
                DispatchQueue.main.async {
                    callback(funcConfig)
                }
            } catch {
                print("捕获异常")
                DispatchQueue.main.async {
                    callback(nil)
                }
            }
        }
        
    }
}
