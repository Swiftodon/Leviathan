//
//  XLogger.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 18.09.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


// MARK: Enums

/**
    All available log levels. They are hierarchical, i.e. if log level Trace
    is set, all messages with a Debug, Info, ... will be logged.
 */
public enum XLogLevel : Int, CustomStringConvertible
{
    case trace   = 1
    case debug   = 2
    case info    = 4
    case warn    = 8
    case error   = 16
    case fatal   = 32
    case none    = 0xffff

    public var description : String {
        get {
            switch(self) {

                case .trace:
                    return "TRACE"

                case .debug:
                    return "DEBUG"

                case .info:
                    return "INFO"

                case .warn:
                    return "WARN"

                case .error:
                    return "ERROR"

                case .fatal:
                    return "FATAL"

                default:
                    return "NONE"

            }
        }
    }
}


// MARK: Type Aliases

/**
    Format a message

    :param: logLevel     The log level of the message
    :param: timestamp    The timestamp of the message
    :param: area         The application area of the message
    :param: message      The message which shall be logged
    :param: functionName Name of the function from which the message is logged
    :param: fileName     Name of the file which the message is logged
    :param: lineNumber   Line number of the log command

    :returns: The formatted message
*/
public typealias XLogFormatter = (_ logLevel: XLogLevel,
                                 _ timestamp: Date,
                                      _ area: String,
                                   _ message: String,
                              _ functionName: String,
                                  _ fileName: String,
                                _ lineNumber: Int) -> String

/**
    Write the log message to a sink.

    :param: message The message to write
*/
public typealias XLogWriter = (_ message: String) -> ()



open class XLogger {

    private static let _dispatchQ : DispatchQueue = {

            let q = DispatchQueue.global()

            q.resume()
            return q
        }()

    // MARK: Public Properties

    /**
        The log level
     */
    open var logLevel : XLogLevel = .info

    /**
        Closure which formmats a message
     */
    open var formatter : XLogFormatter!

    /**
        Closure which writes a message
     */
    open var writer   : XLogWriter!


    // MARK: Private Properties

    fileprivate var _areaLogLevel = Dictionary<String, XLogLevel>()


    // MARK: Initialization

    public init() {

        self.formatter = self.format
        self.writer   = self.write
    }


    // MARK: - Default Instance

    open class func defaultInstance() -> XLogger {

        struct statics {
            static let instance: XLogger = XLogger()
        }

        return statics.instance
    }

    /**
        Set the log level for a specific area.

        :param: area        The area
        :param: logLevel    The log level
    */
    open func setAreaLogLevel(_ area: String, logLevel: XLogLevel) {

        self._areaLogLevel[area] = logLevel
    }


    // MARK: Check Methods

    /**
        Checks whether the given log level is enabled.

        :param: logLevel The log level
        :param: area     Are for which the log level shall be checked.

        :returns: true if the log level is enabled, otherwise false
    */
    open func isLogLevelEnabled(_ logLevel: XLogLevel, area: String? = nil) -> Bool {

        var level     : XLogLevel! = nil
        var isEnabled : Bool

        if area != nil {

            if let lvl = self._areaLogLevel[area!] {

                level = lvl
            }
        }

        if level == nil {

            level = self.logLevel
        }

        isEnabled = level.rawValue <= logLevel.rawValue

        return isEnabled
    }


    // MARK: Log Methods

    /**
        Log a message for the given area.
    
        :param: logLevel     The log level of the message
        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
     */
    open func log(_ logLevel: XLogLevel,
                        area: String,
                     message: String,
                functionName: String = #function,
                    fileName: String = #file,
                  lineNumber: Int = #line) {

        if self.isLogLevelEnabled(logLevel) {

            let timestamp = Date()
            let formatedMessage = self.formatter(logLevel, timestamp, area, message, functionName, fileName, lineNumber)

            self.writer(formatedMessage)
        }
    }

    /**
        Log a Trace message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func trace(_ area: String,
                   message: String,
                   functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.trace,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log a Debug message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func debug(_ area: String,
                   message: String,
              functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.debug,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log an Info message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func info(_ area: String,
                  message: String,
             functionName: String = #function,
                 fileName: String = #file,
               lineNumber: Int = #line) {

            self.log(.info,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log an Info message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func warn(_ area: String,
                  message: String,
             functionName: String = #function,
                 fileName: String = #file,
               lineNumber: Int = #line) {

            self.log(.warn,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log an Error message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func error(_ area: String,
                   message: String,
              functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.error,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }

    /**
        Log a Fatal message for the given area.

        :param: area         The application area of the message
        :param: message      The message which shall be logged
        :param: functionName Name of the function from which the message is logged
        :param: fileName     Name of the file which the message is logged
        :param: lineNumber   Line number of the log command
    */
    open func fatal(_ area: String,
                   message: String,
              functionName: String = #function,
                  fileName: String = #file,
                lineNumber: Int = #line) {

            self.log(.fatal,
                area: area,
                message: message,
                functionName: functionName,
                fileName: fileName,
                lineNumber: lineNumber)
    }


    // MARK: Closure Execution

    /**
        Execute a closure, if the log level is enabled.

        :param: logLevel The log level
        :param: closure  The closure to execute
    */
    open func execute(_ logLevel: XLogLevel, closure: () -> () = {}) {

        if self.isLogLevelEnabled(logLevel) {

            closure()
        }
    }

    open func traceExec(_ closure: () -> () = {}) {

        self.execute(.trace, closure: closure)
    }

    open func debugExec(_ closure: () -> () = {}) {

        self.execute(.debug, closure: closure)
    }

    open func infoExec(_ closure: () -> () = {}) {

        self.execute(.info, closure: closure)
    }

    open func warnExec(_ closure: () -> () = {}) {

        self.execute(.warn, closure: closure)
    }

    open func errorExec(_ closure: () -> () = {}) {

        self.execute(.error, closure: closure)
    }

    open func fatalExec(_ closure: () -> () = {}) {

        self.execute(.fatal, closure: closure)
    }


    // MARK: Default Closure Methods

    fileprivate func format(_ logLevel: XLogLevel,
                       timestamp: Date,
                            area: String,
                         message: String,
                    functionName: String,
                        fileName: String,
                      lineNumber: Int) -> String {

       //
       return "[\(timestamp)] [\(logLevel)] [\(area)] [\(message)] [\(functionName)] [\(fileName)] [\(lineNumber)]"
    }

    fileprivate func write(_ message: String) {

        XLogger._dispatchQ.async {

            NSLog("%@", message)
        }
    }
}


// MARK: Convenience Functions

public func trace(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().trace(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func debug(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().debug(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func info(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().info(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func warn(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().warn(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func error(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().error(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func fatal(_ area: String, message: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().fatal(area, message: message, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
}

public func traceExec(_ closure: () -> () = {}) {

    XLogger.defaultInstance().execute(.trace, closure: closure)
}

public func debugExec(_ closure: () -> () = {}) {

    XLogger.defaultInstance().execute(.debug, closure: closure)
}

public func infoExec(_ closure: () -> () = {}) {

    XLogger.defaultInstance().execute(.info, closure: closure)
}

public func warnExec(_ closure: () -> () = {}) {

    XLogger.defaultInstance().execute(.warn, closure: closure)
}

public func errorExec(_ closure: () -> () = {}) {

    XLogger.defaultInstance().execute(.error, closure: closure)
}

public func fatalExec(_ closure: () -> () = {}) {

    XLogger.defaultInstance().execute(.fatal, closure: closure)
}

public func enter(_ functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().trace("TRACE", message: "ENTER_FUNCTION", functionName: functionName,fileName: fileName, lineNumber: lineNumber)
}

public func leave(_ functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {

    XLogger.defaultInstance().trace("TRACE", message: "LEAVE_FUNCTION", functionName: functionName,fileName: fileName, lineNumber: lineNumber)
}
