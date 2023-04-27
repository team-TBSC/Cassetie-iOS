//
//  LoadingReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/27.
//

import UIKit

import ReactorKit
import RxSwift

class LoadingReactor: Reactor {
    enum Action {
        case set
    }
    
    enum Mutation {
        case setUpdateStatus(Bool)
    }
    
    struct State {
        var isUpdated: Bool = false
    }
    
    var initialState: State
    var completeCassetie: ConfirmMusicResponseDTO = ConfirmMusicResponseDTO.init()
    let disposeBag = DisposeBag()
    
    init() {
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.loading.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .getCassetieInfo(data):
                    self.completeCassetie = data
                    return Observable.concat([
                        .just(.setUpdateStatus(true)),
                        .just(.setUpdateStatus(false))
                    ])
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setUpdateStatus(status):
            newState.isUpdated = status
        }
        
        return newState
    }
}
