//
//  XStack.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 18.09.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

/**
    Class for managing stacks of a specific type.
 */
open class XStack<T> {

    // MARK: Private Properties

    fileprivate var _items : [T] = []


    // MARK: Public Properties

    /**
        Stack Size
     */
    open var size : Int {
        enter()

        defer {
            leave()
        }
        return self._items.count
    }


    // MARK: Initialization

    public init() {
        enter()

        defer {
            leave()
        }
    }


    // MARK: Stack Operations

    /**
        Push the item onto the stack
    
        :param: item The object which shall be pushed
     */
    open func push(_ item : T) {
        enter()

        self._items.append(item)

        defer {
            leave()
        }
    }

    /**
        Pop the top item from the stack and return it.

        :returns: The top item of the stack.
     */
    open func pop() -> T {
        enter()

        let item = self._items.removeLast()

        defer {
            leave()
        }
        return item
    }

    /**
        Returns the topmost item without removing it.
    
        :returns: The topmost item
     */
    open func top() -> T {
        enter()

        let item = self._items.last

        defer {
            leave()
        }
        return item!
    }

    /**
        Returns the second topmost item without removing it
    
        :returns: The second topmost item
     */
    open func second() -> T {
        enter()

        let item = self._items[self.size - 2]

        defer {
            leave()
        }
        return item
    }

    /**
        Duplicates the top of stack
     */
    open func dup() {
        enter()

        let tos = self.top()

        self.push(tos)

        defer {
            leave()
        }
    }

    /**
        Swaps the top of stack and second of stack
     */
    open func swap() {
        enter()

        let tos = self.pop()
        let sec = self.pop()

        self.push(tos)
        self.push(sec)

        defer {
            leave()
        }
    }

    /**
        Clears the stack
     */
    open func clear() {
        enter()

        self._items.removeAll(keepingCapacity: false)

        defer {
            leave()
        }
    }
}
