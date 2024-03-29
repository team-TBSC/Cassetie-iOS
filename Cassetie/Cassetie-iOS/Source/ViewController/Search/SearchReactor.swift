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
        case confirm
    }
    
    enum Mutation {
        case setMusicPreviewSection([SearchSectionModel])
        case setAskQuestionSection([AskQuestionSectionModel])
        case setSelectedMusicList(SelectedMusicList, Int)
        case setSearchIndexKeyword(String, Int)
        case setSearchKeyword(String)
        case updateSelectedMusicIndex
        case setBottomSheetState(Bool)
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
        var searchKeyword: String = String()
        var thirdSearchKeyword: String = String()
        var fourthSearchKeyword: String = String()
        var fivthSearchKeyword: String = String()
        var selectedMusicIndex: Int = 0         // progress view의 진행률을 나타내기 위한 index
        var bottomSheetState: Bool = false      // bottom sheet 닫혔는지 아닌지의 여부
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
            return Observable.just(.setSearchKeyword(text))
        case .confirm:
            let musicList: [MusicListDTO] = currentState.selectedMusicList.map { $0.selectMusic }
            NetworkService.shared.confirm.event.onNext(.updateSelectedMusicList(musicList, currentState.thirdSearchKeyword ,currentState.fourthSearchKeyword, currentState.fivthSearchKeyword))
            return .empty()
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
        case let .setSearchIndexKeyword(word, index):
            if index == 3 {
                newState.thirdSearchKeyword = word
            } else if index == 4 {
                newState.fourthSearchKeyword = word
            } else {
                newState.fivthSearchKeyword = word
            }
        case let .setSearchKeyword(text):
            newState.searchKeyword = text
        case .updateSelectedMusicIndex:
            var index: Int = 0
            
            newState.selectedMusicList.forEach { item in
                if item.isSelected { index += 1 }
            }
            newState.selectedMusicIndex = index
        case let .setBottomSheetState(status):
            newState.bottomSheetState = status
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.search.event
            .flatMap({ [self] (event) -> Observable<Mutation> in
                switch event {
                case let .postMusicList(data):
                    return .just(.setMusicPreviewSection(self.updateMusicPreviewSection(data: data)))
                case let .updateSelectedMusicList(list, index):
                    var updateKeywordMutation: Observable<Mutation> = .empty()
                    
                    // MARK: - 4,5 번째 검색일 때 검색 키워드도 같이 post하기 위함
                    if index + 1 == 3 {
                        updateKeywordMutation = .just(.setSearchIndexKeyword(self.currentState.searchKeyword, 3))
                    } else if index + 1 == 4 {
                        updateKeywordMutation = .just(.setSearchIndexKeyword(self.currentState.searchKeyword, 4))
                    } else {
                        updateKeywordMutation = .just(.setSearchIndexKeyword(self.currentState.searchKeyword, 5))
                    }
                    
                    return Observable.concat([
                        .just(.setSelectedMusicList(self.updateSelectedMusicList(musicList: list), index)),
                        updateKeywordMutation,
                        .just(.updateSelectedMusicIndex)
                    ])
                case .closeBottomSheet:
                    return Observable.concat([
                        .just(.setBottomSheetState(true)),
                        .just(.setBottomSheetState(false))
                    ])
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
        var items: [SearchItem] = []
        
        if data.musicList.isEmpty {
            items.append(.emptyMusicPreview(.noMusic))
        } else {
            data.musicList.forEach { item in
                items.append(.musicPreview(item))
            }
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

