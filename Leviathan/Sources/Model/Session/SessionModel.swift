//
//  SessionModel.swift
//  Leviathan
//
//  Created by Thomas Bonk on 12.11.22.
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

import Foundation
import MastodonSwift
import Valet

fileprivate extension String {
    static let Sessions = "\(String.ApplicationBundleId).SESSIONS"
}

class SessionModel: ObservableObject, Codable {

    // MARK: - Public Static Properties

    static var shared: SessionModel = { decodeSessionModel() }()


    // MARK: - Public Properties

    @Published
    private(set) var sessions: [Session]

    @Published
    private(set) var currentSessionIndex: Int = -1 {
        didSet {
            save()
        }
    }

    var currentSession: Session? {
        guard
            currentSessionIndex >= 0 && currentSessionIndex < sessions.count
        else {
            return nil
        }

        let session = sessions[currentSessionIndex]
        if session.auth == nil {
            session.auth = MastodonClient(baseURL: session.url).getAuthenticated(token: session.accessToken.token)
        }

        return session
    }


    // MARK: - Private Static Properties

    private static var valet: Valet = {
        Valet.iCloudValet(with: Identifier(nonEmpty: .ApplicationBundleId)!, accessibility: .whenUnlocked)
    }()


    // MARK: - Initialization

    private class func decodeSessionModel() -> SessionModel {
        if
            let data = try? valet.object(forKey: .Sessions),
            let model = try? JSONDecoder().decode(SessionModel.self, from: data) {

            return model
        }

        return SessionModel()
    }

    private init() {
        sessions = []
    }


    // MARK: - Public Methods

    func save() {
        DispatchQueue.global(qos: .background).async {
            if let data = try? JSONEncoder().encode(self) {
                try? SessionModel.valet.setObject(data, forKey: .Sessions)
            }
        }
    }

    func logon(instanceURL: URL) {
        Task {
            let scopes = ["read", "write", "follow"]
            let client = MastodonClient(baseURL: instanceURL)
            let app = try await client.createApp(
                      named: "Leviathan",
                redirectUri: "leviathan://oauth-callback",
                     scopes: scopes,
                    website: URL(string: "https://github.com/Swiftodon/Leviathan")!)
            let authToken = try await client.authenticate(app: app, scope: scopes)
            let auth = client.getAuthenticated(token: authToken.oauthToken)
            let account = try await auth.verifyCredentials()
            let session = Session(
                        url: instanceURL,
                accessToken: AccessToken(credential: authToken),
                    account: account)

            mainAsync {
                self.sessions.append(session)
                self.save()
            }
        }
    }

    func remove(session: Session) {
        if let index = sessions.firstIndex(where: { $0 == session }) {
            var oldSelectedSession: Session! = nil

            if index == currentSessionIndex {
                currentSessionIndex = -1
            } else {
                oldSelectedSession = sessions[currentSessionIndex]
            }

            sessions.remove(at: index)

            if let oldSelectedSession {
                select(session: oldSelectedSession)
            }

            save()
        }
    }

    func select(session: Session) {
        guard
            currentSession != session
        else {
            return
        }
        
        if let index = sessions.firstIndex(where: { $0 == session }) {
            currentSessionIndex = index
        }
    }


    // MARK: - Codable

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        sessions = try container.decode([Session].self, forKey: .sessions)
        currentSessionIndex = try container.decode(Int.self, forKey: .currentSessionIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(sessions, forKey: .sessions)
        try container.encode(currentSessionIndex, forKey: .currentSessionIndex)
    }

    private enum CodingKeys: CodingKey {
        case sessions
        case currentSessionIndex
    }
}
