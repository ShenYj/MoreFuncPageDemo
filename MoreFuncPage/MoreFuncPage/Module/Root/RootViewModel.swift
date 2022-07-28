//
//  ViewModel.swift
//  MoreFuncPage
//
//  Created by EZen on 2022/7/28.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

class RootViewModel: BaseViewModel, ViewModelType {
    
}

extension RootViewModel {
    
    struct Input {
        let pushMoreFuncPage: Observable<Void>
    }
    struct Output {
        let pushMoreFuncPage: Observable<Void>
    }
}

extension RootViewModel {
    
    func transform(input: Input) -> Output {
        
        return Output(
            pushMoreFuncPage: input.pushMoreFuncPage.throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
        )
    }
}
