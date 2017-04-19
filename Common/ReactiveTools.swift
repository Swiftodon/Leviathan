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
