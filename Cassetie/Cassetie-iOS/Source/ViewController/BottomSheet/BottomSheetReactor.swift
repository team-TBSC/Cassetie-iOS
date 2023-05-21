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
        
    }
    
    struct State {
        
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
            return .empty()
        }
    }
}
