//
//  Alert.swift
//  Leviathan
//
//  Created by Thomas Bonk on 05.11.22.
//  Copyright 2022 The Swiftodon Team
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AlertToast
import Foundation
import SwiftUI

extension Notification.Name {
    static let ShowAlert = Notification.Name("__SHOW_ALERT__")
}

struct Alert {
    
    // MARK: - Type Aliases
    
    typealias OnTapCallback = (Alert) -> ()
    typealias CompletionCallback = (Alert) -> ()
    
    
    // MARK: - Enums
    
    enum `Type` {
        case info
        case warning
        case error(Error)
        case fatalError(Error)
    }
    
    
    // MARK: - Properties
    
    let type: `Type`
    let message: String
    let duration: Int
    let onTap: OnTapCallback?
    let completion: CompletionCallback?
    
    
    // MARK: - Private Properties
    
    private var title: String {
        switch self.type {
            case .info:
                return "Information"
            case .warning:
                return "Warning"
            case .error(_):
                return "Error"
            case .fatalError(_):
                return "Fatal Error"
        }
    }
    
    private var displayMode: AlertToast.DisplayMode {
        switch self.type {
            case .info, .warning:
                return .banner(.pop)
            default:
                return .alert // TODO: Check whether this is a good choice.
        }
    }
    
    private var alertType: AlertToast.AlertType {
        switch self.type {
            case .info:
                return .systemImage("info.circle.fill", .blue)
            case .warning:
                return .systemImage("exclamationmark.triangle.fill", .yellow)
            case .error(_):
                return .systemImage("exclamationmark.octagon.fill", .red)
            case .fatalError(_):
                return .systemImage("xmark.octagon.fill", .red)
        }
    }
    
    
    // MARK: - Initialization
    
    init(
        type: Alert.`Type`,
        message: String,
        duration: Int? = nil,
        onTap: OnTapCallback? = nil,
        completion: CompletionCallback? = nil) {
            
            self.type = type
            self.message = message
            self.duration = duration ?? 0
            self.onTap = onTap
            
            if case .fatalError(_) = self.type {
                self.completion = { _ in fatalError(message) }
            } else {
                self.completion = completion
            }
        }
    
    
    // MARK: - Methods
    
    func show() {
        NotificationCenter.default.post(name: .ShowAlert, object: self)
    }
    
    func toast() -> AlertToast {
        var msg = message
        
        if case let .error(err) = type {
            msg = "\(message)\n\n\(err.localizedDescription)"
        } else if case let .fatalError(err) = type {
            msg = "\(message)\n\n\(err.localizedDescription)"
        }
        
        return AlertToast(displayMode: displayMode,
                          type: alertType,
                          title: title,
                          subTitle: msg,
                          style: .style(titleFont: .title, subTitleFont: .body))
    }
}
