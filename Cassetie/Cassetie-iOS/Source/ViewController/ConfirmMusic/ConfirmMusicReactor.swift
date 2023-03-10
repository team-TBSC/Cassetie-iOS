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
        case refresh
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
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .just(.setMusicPreviewSection(createMusicPreviewSection()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setMusicPreviewSection(section):
            newState.musicPreviewSection = section
        }
        
        return newState
    }
    
    func createMusicPreviewSection() -> [SearchSectionModel] {
        let testModels:[MusicPreviewModel] = [
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브")
        ]
        
        let items = testModels.map { item -> SearchItem in
            return .musicPreview(item)
        }
        
        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
        
        return [searchSection]
    }
}
