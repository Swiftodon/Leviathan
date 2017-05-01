//
//  Observable+Extensions.swift
//  Leviathan
//
//  Created by Thomas Bonk on 01.05.17.
//
//

import Foundation
import RxSwift
import RxCocoa

extension Observable {
    /**
     Simulation of a discrete system with feedback loops.
     Interpretations:
     - [system with feedback loops](https://en.wikipedia.org/wiki/Control_theory)
     - [fixpoint solver](https://en.wikipedia.org/wiki/Fixed_point)
     - [local equilibrium point calculator](https://en.wikipedia.org/wiki/Mechanical_equilibrium)
     - ....
     
     System simulation will be started upon subscription and stopped after subscription is disposed.
     
     System state is represented as a `State` parameter.
     Commands are represented by `Element` parameter.
     
     - parameter initialState: Initial state of the system.
     - parameter accumulator: Calculates new system state from existing state and a transition command (system integrator, reducer).
     - parameter feedback: Feedback loops that produce commands depending on current system state.
     - returns: Current state of the system.
     */
    public static func system<State>(
        _ initialState: State,
        accumulator: @escaping (State, Element) -> State,
        scheduler: SchedulerType,
        feedback: (Observable<State>) -> Observable<Element>...
        ) -> Observable<State> {
        return Observable<State>.deferred {
            let replaySubject = ReplaySubject<State>.create(bufferSize: 1)
            
            let inputs: Observable<Element> = Observable.merge(feedback.map { $0(replaySubject.asObservable()) })
                .observeOn(scheduler)
            
            return inputs.scan(initialState, accumulator: accumulator)
                .startWith(initialState)
                .do(onNext: { output in
                    replaySubject.onNext(output)
                })
        }
    }
}
