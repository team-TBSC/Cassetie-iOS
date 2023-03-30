//
//  SearchReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/02/27.
//

import UIKit

import ReactorKit
import RxSwift

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
    let disposeBag = DisposeBag()
    let service = SearchService()
    
    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            service.post(text: "after")
            return Observable.concat([
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
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .postMusicList(data):
                    return .just(.setMusicPreviewSection(self.updateMusicPreviewSection(data: data)))
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
   
    
//    func createMusicPreviewSection() -> [SearchSectionModel] {
//        postSearchMusic()
//
//        let testModels:[MusicPreviewModel] = [
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like", singer: "아이브"),
//        ]
//
//        let items = testModels.map { item -> SearchItem in
//            return .musicPreview(item)
//        }
//
//        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
//
//        return [searchSection]
//    }
//
    
    func updateMusicPreviewSection(data: SearchResponseDTO) -> [SearchSectionModel] {
        let items = data.musicList.map { item -> SearchItem in
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

