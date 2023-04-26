//
//  ConfirmMusicReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/10.
//

import UIKit

import ReactorKit

enum SearchKeywordIndex {
    // MARK: - 몇 번째 질문에 대한 검색 키워드인지 구분해주는 enum
    case third
    case fourth
    case fivth
    
    var num: Int {
        switch self {
        case .third:
            return 3
        case .fourth:
            return 4
        case .fivth:
            return 5
        }
    }
}

class ConfirmMusicReactor: Reactor {
    enum Action {
        case post
    }
    
    enum Mutation {
        case setMusicPreviewSection([SearchSectionModel])
        case setSearchKeyword(String, SearchKeywordIndex)
        case setMusicList([MusicListDTO])
    }
    
    struct State {
        var musicPreviewSection: [SearchSectionModel] = []
        var thirdKeyword: String = String()
        var fourthKeyword: String = String()
        var fivthKeyword: String = String()
        var selectRequestDTO: SelectedRequestDTO = SelectedRequestDTO.init()
        var musicList: [MusicListDTO] = []
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
        case let .setSearchKeyword(text, type):
            if type.num == 3 {
                newState.thirdKeyword = text
            } else if type.num == 4 {
                newState.fourthKeyword = text
            } else {
                newState.fivthKeyword = text
            }
        case let .setMusicList(list):
            newState.musicList = list
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.confirm.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .updateSelectedMusicList(list, keyword3, keyword4, keyword5):
                    return Observable.concat([
                        .just(.setMusicPreviewSection(self.createMusicPreviewSection(musicList: list))),
                        .just(.setMusicList(list)),
                        .just(.setSearchKeyword(keyword3, .third)),
                        .just(.setSearchKeyword(keyword4, .fourth)),
                        .just(.setSearchKeyword(keyword5, .fivth))
                    ])
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .post:
            NetworkService.shared.confirm.post(data: createSelectRequestDTO())
            return .empty()
        }
    }
    
    func createSelectRequestDTO() -> SelectedRequestDTO {
        let musicList: [MusicListDTO] = currentState.musicList
        let requestDTO = SelectedRequestDTO(name: "카세티2호", song1ID: musicList[0].id, song2ID: musicList[1].id, song3ID: musicList[2].id, song3Search: currentState.thirdKeyword, song4ID: musicList[3].id, song4Search: currentState.fourthKeyword, song5ID: musicList[4].id, song5Search: currentState.fivthKeyword)
        
        return requestDTO
    }
    
    func createMusicPreviewSection(musicList: [MusicListDTO]) -> [SearchSectionModel] {
        let items = musicList.map { item -> SearchItem in
            return .musicPreview(item)
        }
        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
        
        return [searchSection]
    }
}
