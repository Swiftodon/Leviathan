//
//  XTypedNotification.swift
//  
//
//  Created by Thomas Bonk on 28.01.15.
//
//

import Foundation


open class XBox<T> {

    // MARK: Public Properties

    open let unbox: T


    // MARK: Initialization

    public init(_ value: T) {
        enter()

        self.unbox = value

        defer {
            leave()
        }
    }
}


public struct XNotification<A> {

    public let name: String
}


open class XNotificationObserver {

    // MARK: Public Properties

    open let observer: NSObjectProtocol


    // MARK: Initialization

    public init<A>(notification: XNotification<A>, block aBlock: @escaping (A) -> ()) {
        enter()

        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notification.name), object: nil, queue: nil) { note in

            if let value = ((note as NSNotification).userInfo?["value"] as? XBox<A>)?.unbox {

                aBlock(value)
            } else {

                assert(false, "Couldn't understand user info")
            }
        }

        defer {
            leave()
        }
    }

    deinit {
        enter()

        NotificationCenter.default.removeObserver(observer)

        defer {
            leave()
        }
    }

}


public func postNotification<A>(_ note: XNotification<A>, value: A) {
    enter()

    let userInfo = ["value": XBox(value)]

    NotificationCenter.default.post(name: Notification.Name(rawValue: note.name), object: nil, userInfo: userInfo)

    defer {
        leave()
    }
}
