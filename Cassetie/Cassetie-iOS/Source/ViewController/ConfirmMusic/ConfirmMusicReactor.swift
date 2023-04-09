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
        case post
    }
    
    enum Mutation {
        case setMusicPreviewSection([SearchSectionModel])
        case setSearchKeyword(String, Int)
    }
    
    struct State {
        var musicPreviewSection: [SearchSectionModel] = []
        var fourthKeyword: String = String()
        var fivthKeyword: String = String()
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
        case let .setSearchKeyword(text, index):
            if index == 4 {
                newState.fourthKeyword = text
            } else {
                newState.fivthKeyword = text
            }
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.confirm.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .updateSelectedMusicList(list, keyword4, keyword5):
                    return Observable.concat([
                        .just(.setMusicPreviewSection(self.createMusicPreviewSection(musicList: list))),
                        .just(.setSearchKeyword(keyword4, 4)),
                        .just(.setSearchKeyword(keyword5, 5))
                    ])
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func createMusicPreviewSection(musicList: [MusicListDTO]) -> [SearchSectionModel] {
        let items = musicList.map { item -> SearchItem in
            return .musicPreview(item)
        }
        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
        
        return [searchSection]
    }
}
