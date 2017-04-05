//
//  XCommandBusError.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 03.11.15.
//  Copyright © 2015 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

/**
    Errors that can be thrown by the command bus
*/
public enum XCommandBusError: Error {

    case classNotACommand
    case commandNotRegistered
}
