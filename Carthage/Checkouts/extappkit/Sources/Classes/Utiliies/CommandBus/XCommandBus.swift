//
//  XCommandBus.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 03.11.15.
//  Copyright © 2015 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/** 
    Class that provides a CommandBus implementation.
*/
open class XCommandBus {

    // MARK: Class Constants

    private static let _instance : XCommandBus = { XCommandBus() }()


    // MARK: Public Types

    public typealias CommandHandler = (XCommand) -> ()


    // MARK: Private Types

    fileprivate typealias CommandHandlerTuple = (AnyObject, CommandHandler)


    // MARK: Private Properties

    fileprivate var _commandHandlerDirectory = [String:Array<CommandHandlerTuple>]()


    // MARK: Singleton Property

    /**
        :var:       sharedInstance
        :abstract:  Retrieve the singleton instance of the command bus.
    */
    open class var sharedInstance : XCommandBus {
        enter()

        defer {
            leave()
        }

        return XCommandBus._instance
    }


    // MARK: Public Methods

    open func registerHandler(_ object: AnyObject, commandHandler: @escaping CommandHandler, command: AnyClass) throws {
        enter()

        guard let _ = command as? XCommand.Type else {

            throw XCommandBusError.classNotACommand
        }

        let mirror = Mirror(reflecting: command)
        let commandId = String(describing: mirror.subjectType).characters.split{$0 == "."}.map(String.init)[0]
        var handlers: Array<CommandHandlerTuple>? = nil

        if self._commandHandlerDirectory.keys.contains(commandId) {

            handlers = self._commandHandlerDirectory[commandId]
        }
        else {

            handlers = Array<CommandHandlerTuple>()
        }

        handlers?.append((object, commandHandler))
        self._commandHandlerDirectory[commandId] = handlers

        defer {
            leave()
        }
    }

    open func removeHandler(_ object: AnyObject, command: AnyClass) throws {
        enter()

        guard let _ = command as? XCommand.Type else {

            throw XCommandBusError.classNotACommand
        }

        let mirror = Mirror(reflecting: command)
        let commandId = String(describing: mirror.subjectType).characters.split{$0 == "."}.map(String.init)[0]

        guard self._commandHandlerDirectory.keys.contains(commandId) else {

            throw XCommandBusError.commandNotRegistered
        }

        var handlers = self._commandHandlerDirectory[commandId]

        handlers = handlers!.filter({ $0.0 !== object })

        if handlers?.count > 0 {

            self._commandHandlerDirectory[commandId] = handlers
        }
        else {

            self._commandHandlerDirectory.removeValue(forKey: commandId)
        }

        defer {
            leave()
        }
    }

    open func sendCommand(_ command: XCommand) {
        enter()

        let mirror = Mirror(reflecting: command.self)
        let commandId = String(describing: mirror.subjectType)

        if let handlers = self._commandHandlerDirectory[commandId] {

            for handler in handlers {

                performAsync {

                    handler.1(command)
                }
            }
        }

        defer {
            leave()
        }
    }
}
