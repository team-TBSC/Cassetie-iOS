//
//  ConfirmMusicReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/10.
//

import UIKit

import ReactorKit

class ConfirmMusicReactor: Reactor {
    enum Action {
    }
    
    enum Mutation {
        case setMusicPreviewSection([SearchSectionModel])
    }
    
    struct State {
        var musicPreviewSection: [SearchSectionModel] = []
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setMusicPreviewSection(section):
            newState.musicPreviewSection = section
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.confirm.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .updateSelectedMusicList(list):
                    return .just(.setMusicPreviewSection(self.createMusicPreviewSection(musicList: list)))
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func createMusicPreviewSection(musicList: [MusicListDTO]) -> [SearchSectionModel] {

        let items = musicList.map { item -> SearchItem in
            return .musicPreview(item)
        }
        print(items)
        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
        
        return [searchSection]
    }
}
