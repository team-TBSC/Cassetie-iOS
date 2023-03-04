//
//  SearchReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/02/27.
//

import UIKit

import ReactorKit

class SearchReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setMusicPreviewSection([SearchSectionModel])
        case setAskQuestionSection([AskQuestionSectionModel])
    }
    
    struct State {
        var musicPreviewSection: [SearchSectionModel] = []
        var askQuestionSection: [AskQuestionSectionModel] = []
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                .just(.setMusicPreviewSection(createMusicPreviewSection())),
                .just(.setAskQuestionSection(createAskQuestionSection()))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setMusicPreviewSection(section):
            newState.musicPreviewSection = section
        case let .setAskQuestionSection(section):
            newState.askQuestionSection = section
        }
        
        return newState
    }
    
    func createMusicPreviewSection() -> [SearchSectionModel] {
        let testModels:[MusicPreviewModel] = [
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
        ]
        
        let items = testModels.map { item -> SearchItem in
            return .musicPreview(item)
        }
        
        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
        
        return [searchSection]
    }
    
    func createAskQuestionSection() -> [AskQuestionSectionModel] {
        let items = QuestionType.allCases.map {
            return AskQuestionItem.askQuestion($0)
        }
        
        let section = AskQuestionSectionModel(model: .askQuestion(items), items: items)
        
        return [section]
    }
}

