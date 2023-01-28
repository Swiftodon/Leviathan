//
//  TimelineViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 28.01.23.
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

import Combine
import Foundation
import SwiftUI
import UIKit

class TimelineViewController: UITableViewController {
    
    
    
    // MARK: - Private properties for session selection
    
    private var sessionModelCancellable: AnyCancellable? = nil
    private var selectedSession: Session? = SessionModel.shared.currentSession {
        didSet {
            // TODO
        }
    }
    
    
    // MARK: - Private properties for timeline selection
    
    private var selectedTimeline: TimelineId = .home {
        didSet {
            timelinePickerButton.setTitle(timelines[Int(selectedTimeline.rawValue)].0, for: .normal)
        }
    }
    private let timelines = [
        ("Home", TimelineId.home),
        ("Local", TimelineId.local),
        ("Fedi", TimelineId.federated)
    ]
    private var timelinePickerButton = UIButton(type: .custom)
    
    
    // MARK: - Private properties for UI controls
    
    @IBOutlet
    private var accountSelectorButton: UIBarButtonItem!
    
    
    // MARK: - Initialization and deinitialization
    
    deinit {
        sessionModelCancellable?.cancel()
    }
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionModelCancellable = SessionModel.shared.objectWillChange.sink(receiveValue: sessionUpdated)
        createTimelinePicker()
        
        if let selectedSession, let avatarUrl = selectedSession.account.avatar {
            UIImage.asyncLoad(url: avatarUrl, defaultImage: UIImage(systemName: "person.fill")?.frame(width: 32, height: 32)) { image in
                self.accountSelectorButton.image = image?.frame(width: 32, height: 32)
            }
        } else {
            accountSelectorButton.image = UIImage(systemName: "person.fill")?.frame(width: 32, height: 32)
        }
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction func selectAccount() {
        // TODO
        let menuViewController = UIHostingController(rootView: MenuView().environmentObject(SessionModel.shared))
        if let sheet = menuViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(menuViewController, animated: true, completion: nil)
    }
    
    @IBAction func composeToot() {
        // TODO
    }
    
    
    // MARK: - Session changes
    
    private func sessionUpdated() {
        mainAsync {
            self.selectedSession = SessionModel.shared.currentSession
        }
    }
    
    
    // MARK: - Private UI related methods
    
    private func createTimelinePicker() {
        let menu = UIMenu(
            title: "Timeline",
            image: UIImage(systemName: "chevron.down"),
            children: timelines.map({ timeline in
                UIAction(
                    title: timeline.0,
                    identifier: .init("\(timeline.1.rawValue)")) { action in
                        self.selectedTimeline = TimelineId(rawValue: Int16(action.identifier.rawValue)!)!
                    }
            }))
        timelinePickerButton.menu = menu
        timelinePickerButton.showsMenuAsPrimaryAction = true
        timelinePickerButton.setTitle(timelines[Int(selectedTimeline.rawValue)].0, for: .normal)
        timelinePickerButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)

        self.navigationItem.titleView = timelinePickerButton
    }
}
