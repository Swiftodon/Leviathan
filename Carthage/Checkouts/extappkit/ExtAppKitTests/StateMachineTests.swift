//
//  StateMachineTests.swift
//  ExtAppKit
//
//  Created by Bonk, Thomas on 13.02.17.
//  Copyright © 2017 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import XCTest
import ExtAppKit

enum States: Int, XStateType {

    case State0 = 0
    case State1 = 1
    case State2 = 2
}

enum Events: Int, XEventType {

    case Event0 = 0
    case Event1 = 1
}

class StateMachineTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTransition() {
        
        let stateMachine = XStateMachine<States, NoEvents>(initialState: .State0)

        do {

            try stateMachine += (.State0, .State1)
        }
        catch {

            XCTFail("State Machine threw error while defining transitioning from .State0 to .State1")
        }

        do {

            try stateMachine => .State1
            XCTAssert(stateMachine.state == .State1, "State Machine is not in .State1")
        }
        catch {

            XCTFail("State Machine threw error while transitioning from .State0 to .State1")
        }
    }

    func testNonDeterministicTransition() {

        let stateMachine = XStateMachine<States, NoEvents>(initialState: .State0)

        do {

            try stateMachine += (.State0, .State1)
            try stateMachine += (.State0, .State1)
            XCTFail("State Machine didn't throw error while defining transitioning from .State0 to .State1 twice")
        }
        catch {}
    }

    func testTransitionFails() {

        let stateMachine = XStateMachine<States, NoEvents>(initialState: .State0)

        do {

            try stateMachine += (.State0, .State1)
        }
        catch {

            XCTFail("State Machine threw error while defining transitioning from .State0 to .State1")
        }

        do {

            try stateMachine => .State2
            XCTFail("State Machine didn't threw error while transitioning from .State0 to .State2")
        }
        catch {}
    }

    func testTransitionOnEvent() {

        let stateMachine = XStateMachine<States, Events>(initialState: .State0)

        do {

            try stateMachine += (.Event0, .State0, .State1)
        }
        catch {

            XCTFail("State Machine threw error while defining transitioning from .State0 to .State1 in case of event .Event0")
        }

        do {

            try .Event0 => stateMachine
            XCTAssert(stateMachine.state == .State1, "State Machine is not in .State1")
        }
        catch {

            XCTFail("State Machine threw error while transitioning from .State0 to .State1")
        }
    }
    
    func testTransitionOnEventFail() {
        
        let stateMachine = XStateMachine<States, Events>(initialState: .State0)
        
        do {
            
            try stateMachine += (.Event0, .State0, .State1)
        }
        catch {
            
            XCTFail("State Machine threw error while defining transitioning from .State0 to .State1 in case of event .Event0")
        }
        
        do {
            
            try .Event1 => stateMachine
            XCTFail("State Machine transitioned on event .Event1 allthough it shouldn't")
        }
        catch {}
    }
}
