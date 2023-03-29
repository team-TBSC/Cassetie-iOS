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
        case musicSelect(Int, MusicListDTO)
    }
    
    enum Mutation {
        case setMusicPreviewSection([SearchSectionModel])
        case setSelectedMusic([SearchSectionModel])
    }
    
    struct State {
        var musicPreviewSection: [SearchSectionModel] = []
        var selectedMusicSection: [SearchSectionModel] = []
    }
    
    var initialState: State
    var selectedMusicModel: [MusicListDTO] = [
        MusicListDTO(track: "", artist: "", album: "", image: "", previewURL: "", id: "")
    ]
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .just(.setMusicPreviewSection(createMusicPreviewSection()))
        case let .musicSelect(index, model):
            return .just(.setSelectedMusic(updateSelectedMusicSection(index: index, model: model)))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setMusicPreviewSection(section):
            newState.musicPreviewSection = section
        case let .setSelectedMusic(section):
            newState.selectedMusicSection = section
        }
        
        return newState
    }
    
    func createMusicPreviewSection() -> [SearchSectionModel] {
//        let testModels:[MusicPreviewModel] = [
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like 1", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like 2", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like 4", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like 1", singer: "아이브"),
//        MusicPreviewModel(albumImage: Image.testAlbumImage, title: "After Like ", singer: "아이브")
//        ]
        
        let testModels: [MusicListDTO] = [
        MusicListDTO(track: "After LIKE", artist: "IVE", album: "After Like", image: "", previewURL: "", id: ""),
        MusicListDTO(track: "After LIKE", artist: "IVE", album: "After Like", image: "", previewURL: "", id: "")
        ]
        
        let items = testModels.map { item -> SearchItem in
            return .musicPreview(item)
        }
        
        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
        
        return [searchSection]
    }
    
    func updateSelectedMusicSection(index: Int, model: MusicListDTO) -> [SearchSectionModel] {
        selectedMusicModel[index] = model
        
        let items = selectedMusicModel.map { item -> SearchItem in
            return .musicPreview(item)
        }
        
        let searchSection = SearchSectionModel(model: .musicPreview(items), items: items)
        return [searchSection]
    }
}
