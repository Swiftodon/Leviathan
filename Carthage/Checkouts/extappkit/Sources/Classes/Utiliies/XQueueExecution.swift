//
//  XQueueExecution.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 28.09.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


// MARK: Queue Handles

private let _mainQ       : DispatchQueue! = { DispatchQueue.main }()
private let _backgroundQ : DispatchQueue! = { DispatchQueue.global() }()


// MARK: Entry Counter

private var entryCounters: [String:Int] = [:]


// MARK: Perform Blocks

private func increaseEntryCounter(_ queueKey: String) {
    enter()

    if let _ = entryCounters[queueKey] {

        entryCounters[queueKey]! += 1
    }
    else {

        entryCounters[queueKey] = 1
    }

    leave()
}

private func decreaseEntryCounter(_ queueKey: String) {
    enter()

    if let _ = entryCounters[queueKey] {

        entryCounters[queueKey]! -= 1
    }
    else {

        entryCounters[queueKey] = 0
    }

    leave()
}

/**
 Execute the given block on the given queue and wait until it finished.

 :param: queue   the queue on which the block is executed
 :param: block   the block to execute
 */
public func perform(_ queue: DispatchQueue, block: () -> ()) {
    enter()

    let queueKey = String(describing: queue)
    var executeInQ = true

    if let _ = entryCounters[queueKey] {

        executeInQ = (entryCounters[queueKey]! == 0)
    }

    if executeInQ {

        queue.sync {

            increaseEntryCounter(queueKey)
            block()
            decreaseEntryCounter(queueKey)
        }
    }
    else {

        block()
    }

    leave()
}

/**
 Execute the given block on the given queue and continue.

 :param: queue   the queue on which the block is executed
 :param: block   the block to execute
 */
public func performAsync(_ queue: DispatchQueue, block: @escaping () -> ()) {
    enter()

    queue.async(execute: block)

    leave()
}

/**
    Execute the given block on the main queue and wait until it finished.

    :param: block   the block to execute
*/
public func perform(_ block: () -> ()) {
    enter()

    perform(_mainQ, block: block)

    leave()
}

/**
    Execute the given block on the main queue and continue.

    :param: block   the block to execute
*/
public func performAsync(_ block: @escaping () -> ()) {
    enter()

    performAsync(_mainQ, block: block)

    leave()
}

/**
    Execute the given block on the background queue and wait until it finished.

    :param: block   the block to execute
*/
public func performBackground(_ block: () -> ()) {
    enter()

    perform(_backgroundQ, block: block)

    leave()
}

/**
    Execute the given block on the main queue and continue.

    :param: block   the block to execute
*/
public func performBackgroundAsync(_ block: @escaping () -> ()) {
    enter()

    performAsync(_backgroundQ, block: block)

    leave()
}

/**
    Execute the given block synchronized to the passed lock object.

    :param: lock    The lock object
*/
public func synchronized(_ lock: AnyObject, closure: () -> ()) {
    enter()

    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)

    leave()
}
