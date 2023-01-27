//
//  Session.swift
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

class Session: ObservableObject, Codable, Hashable, Equatable, Identifiable {

    // MARK: - Public Properties

    var id: String { account.id }
    private(set) var url: URL
    private(set) var accessToken: AccessToken
    private(set) var account: Account
    var auth: MastodonClientAuthenticated? = nil


    // MARK: - Initialization

    init(url: URL, accessToken: AccessToken, account: Account) {
        self.url = url
        self.accessToken = accessToken
        self.account = account
    }


    // MARK: - Equatble

    static func == (lhs: Session, rhs: Session) -> Bool {
        lhs.account.id == rhs.account.id
    }


    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }


    // MARK: - Codable

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        url = try container.decode(URL.self, forKey: .url)
        accessToken = try container.decode(AccessToken.self, forKey: .accessToken)
        account = try container.decode(Account.self, forKey: .account)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(url, forKey: .url)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(account, forKey: .account)
    }

    private enum CodingKeys: CodingKey {
        case url
        case accessToken
        case account
    }
}
