//
//  TimelineDataSource.swift
//  Leviathan
//
//  Created by Thomas Bonk on 20.05.17.
//
//

import UIKit
import RxSwift
import Moya
import MastodonSwift


class TimelineDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Type Aliases
    
    typealias TimelineRetriever = (StatusId?, StatusId?) -> RxSwift.Observable<[MastodonSwift.Status]>
    
    
    // MARK: - Private Properties
    
    private var timeline: Leviathan.Timeline!
    private var account: Leviathan.Account! = nil
    private var client: MastodonClient! = nil
    private var timelineRetriever: TimelineRetriever! = nil
    
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let dispoaseBag = DisposeBag()
    
    
    // MARK: - Public Properties
    
    public private(set) var statuses = Variable<[MastodonSwift.Status]>([])
    
    
    // MARK: - Initialization
    
    init(_ timeline: Leviathan.Timeline) {
        super.init()
    
        self.timeline = timeline
        self.baseInit()
    }
    
    private func baseInit() {
        guard let _ = settings else {
            preconditionFailure()
        }
        
        self.initializeForAccount(settings?.activeAccount)
        self.settings?.accountSubject.subscribe { event in
            switch event {
            case .next(let account):
                self.initializeForAccount(account)
            default:
                break
            }
            }.addDisposableTo(dispoaseBag)
        self.updateTimeline()
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.statuses.value.count
    }
    
    
    // MARK: - Public Methods
    
    func updateTimeline() {
        
        self.timelineRetriever(nil, nil)
            .subscribe(
                EventHandler(
                    onNext: { statuses in
                        
                        self.statuses.value.insert(contentsOf: statuses, at: 0)
                    },
                    onError: { err in
                        
                    },
                    onCompleted: {
                        // Do Nothing
                    }))
            .disposed(by: self.dispoaseBag)
    }

    
    // MARK: - Private Methods
    
    private func initializeForAccount(_ account: Leviathan.Account?) {
        
        self.account = account
        self.client = MastodonClient(plugins: [AccessTokenPlugin(token: (account?.accessToken?.token)!)])
        self.timelineRetriever = self.retrieveTimelineRetriever()
    }
    
    private func retrieveTimelineRetriever() -> TimelineRetriever? {
        
        switch self.timeline! {
        case .Home:
            return { maxId, sinceId in
                
                return self.client.getHomeTimeline((self.account.accessToken?.token)!,
                                            maxId: maxId,
                                            sinceId: sinceId,
                                            endpointClosure: /self.account.baseUrl)
            }
            
        case .Local:
            return { maxId, sinceId in
                
                return self.client.getPublicTimeline((self.account.accessToken?.token)!,
                                                     isLocal: true,
                                                     maxId: maxId,
                                                     sinceId: sinceId,
                                                     endpointClosure: /self.account.baseUrl)
            }
            
        case .Federated:
            return { maxId, sinceId in
                
                return self.client.getPublicTimeline((self.account.accessToken?.token)!,
                                                     isLocal: false,
                                                     maxId: maxId,
                                                     sinceId: sinceId,
                                                     endpointClosure: /self.account.baseUrl)
            }
            
        default:
            return nil
        }
    }
}
