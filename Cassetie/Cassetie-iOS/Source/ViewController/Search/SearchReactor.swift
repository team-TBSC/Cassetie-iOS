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
        case update(String)
    }
    
    enum Mutation {
        case setMusicPreviewSection([SearchSectionModel])
        case setAskQuestionSection([AskQuestionSectionModel])
        case setSelectedMusicList(SelectedMusicList, Int)
    }
    
    struct State {
        var musicPreviewSection: [SearchSectionModel] = []
        var askQuestionSection: [AskQuestionSectionModel] = []
        var selectedMusicList: [SelectedMusicList] = [
            SelectedMusicList(selectMusic: MusicListDTO.init(), isSelected: false),
            SelectedMusicList(selectMusic: MusicListDTO.init(), isSelected: false),
            SelectedMusicList(selectMusic: MusicListDTO.init(), isSelected: false),
            SelectedMusicList(selectMusic: MusicListDTO.init(), isSelected: false),
            SelectedMusicList(selectMusic: MusicListDTO.init(), isSelected: false)
        ]
    }
    
    var initialState: State
    let disposeBag = DisposeBag()
    
    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat([
                .just(.setAskQuestionSection(createAskQuestionSection())),
                .just(.setMusicPreviewSection(createMusicPreviewSection()))
            ])
        case let .update(text):
            NetworkService.shared.search.post(text: text)
            return Observable.empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setMusicPreviewSection(section):
            newState.musicPreviewSection = section
        case let .setAskQuestionSection(section):
            newState.askQuestionSection = section
        case let .setSelectedMusicList(list, index):
            var newSelectedMusicList = newState.selectedMusicList
            newSelectedMusicList[index] = list
            newState.selectedMusicList = newSelectedMusicList
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.search.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .postMusicList(data):
                    return .just(.setMusicPreviewSection(self.updateMusicPreviewSection(data: data)))
                case let .updateSelectedMusicList(list, index):
                    return .just(.setSelectedMusicList(self.updateSelectedMusicList(musicList: list), index))
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func createMusicPreviewSection() -> [SearchSectionModel] {
        let item : [SearchItem] = [.emptyMusicPreview(.refresh)]
        let searchSection = SearchSectionModel(model: .musicPreview(item), items: item)
        
        return [searchSection]
    }
    
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
    
    func updateSelectedMusicList(musicList: MusicListDTO) -> SelectedMusicList {
        let musicList = SelectedMusicList(selectMusic: musicList, isSelected: true)

        return musicList
    }
}

