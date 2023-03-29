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
        case setMusicListSection(SearchResponseDTO) // 이부분 setMusicPreviewSection으로 합체 해야함
    }
    
    struct State {
        var musicPreviewSection: [SearchSectionModel] = []
        var askQuestionSection: [AskQuestionSectionModel] = []
        var musicListSection: SearchResponseDTO = .init(musicList: []) // 일단 연습용
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
            service.testPost(text: "after")
            return Observable.concat([
//                .just(.setMusicPreviewSection(updateMusicPreviewSection())),
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
        case let .setMusicListSection(section):
            newState.musicListSection = section
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .postMusicList(data):
                    return .just(.setMusicPreviewSection(self.testSection(data: data)))
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
    
//    func postSearchMusic() {
//        let searchService = SearchService()
//        print("-----------post search music --------")
//
//        searchService.post(text: "after")
//            .compactMap { $0 }
//            .withUnretained(self)
//            .subscribe(onNext: { this, data in
//                print(data)
//            })
//            .disposed(by: disposeBag)
//    }
    
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
    
//    func updateMusicPreviewSection() -> [SearchSectionModel] {
//        let searchService = SearchService()
//        print("-----------post search music --------")
//
//        var result: [MusicListDTO] = []
//        let data = searchService.post(text: "after")
//            .compactMap { $0 }
//            .withUnretained(self)
//            .subscribe(onNext: { this, data in
//                result =  data.musicList
//            })
//            .disposed(by: disposeBag)
//
//        let items = result.map { item -> SearchItem in
//            return .musicPreview(item)
//        }
//
//        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
//
//        return [searchSection]
//    }
//
    func testSection(data: SearchResponseDTO) -> [SearchSectionModel] {
        print("-------- ✅testSection --------")
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

