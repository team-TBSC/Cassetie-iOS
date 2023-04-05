//
//  BottomSheetReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/05.
//

import UIKit

import ReactorKit
import RxSwift

class BottomSheetReactor: Reactor {
    enum Action {
        case select(MusicListDTO, Int)
    }
    
    enum Mutation {
        case setIsSelected(Bool)
    }
    
    struct State {
        var isSelected: Bool = false
    }
    
    var initialState: State
    let disposeBag = DisposeBag()
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .select(list, index):
            NetworkService.shared.search.event.onNext(.updateSelectedMusicList(list, index))
            return Observable.concat([
                .just(.setIsSelected(true)),
                .just(.setIsSelected(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setIsSelected(status):
            newState.isSelected = status
        }
        
        return newState
    }
}
