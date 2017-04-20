//
//  ReactiveTools.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 19.04.17.
//
//

import Foundation
import RxCocoa
import RxSwift

// Bind a control to a variable
infix operator <->
func <-> <T>(control: ControlProperty<T>, variable: Variable<T>) -> Disposable{
    
    let variableDisposable = variable.asObservable().bind(to: control)
    let controlDisposable = control.bind(to: variable)
    
    return CompositeDisposable.init(disposables: [variableDisposable, controlDisposable])
}


// split the event in next, error and completed
func EventHandler<T>(onNext: @escaping (T) -> Void,
                  onError: ((Swift.Error) -> Void)? = nil,
                  onCompleted: (() -> Void)? = nil ) -> ((Event<T>) -> Void) {
    
    return { event in
        
        switch event {
        case .next(let element):
            onNext(element)
            break
            
        case .completed:
            guard onCompleted != nil else {
                return
            }
            onCompleted?()
            break
            
        case .error(let error):
            guard onError != nil else {
                return
            }
            onError?(error)
            break
        }
    }
}
