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
        case let .setSearchKeyword(text, index):
            if index == 3 {
                newState.thirdKeyword = text
            } else if index == 4 {
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
                        .just(.setSearchKeyword(keyword3, 3)),
                        .just(.setSearchKeyword(keyword4, 4)),
                        .just(.setSearchKeyword(keyword5, 5))
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
