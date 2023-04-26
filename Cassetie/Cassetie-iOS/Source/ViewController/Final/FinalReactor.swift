//
//  FinalReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/21.
//

import UIKit

import ReactorKit

class FinalReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setFinalSection([FinalSectionModel])
    }
    
    struct State {
        var finalSection: [FinalSectionModel] = []
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            NetworkService.shared.final.get()
            return .empty()
//            return .just(.setFinalSection(createSection()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setFinalSection(section):
            newState.finalSection = section
        }
        
        return newState
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.final.event
                .flatMap({ (event) -> Observable<Mutation> in
                    switch event {
                    case let .updateAllCassetie(data):
                        return Observable.concat([
                            .just(.setFinalSection(self.createSection(data: data)))
                        ])
                    }
                })
    
            return Observable.merge(mutation, eventMutation)
        }
    
    func createSection(data: FinalResponseDTO) -> [FinalSectionModel] {
        let cassetieData: [CassetieInfoDTO] = data.dbData.map { item in
            let genre = String(item.num[item.num.index(item.num.startIndex, offsetBy: 2)])
            return .init(name: item.name, num: genre)
        }

        let items: [FinalItem] = cassetieData.map { item in
            return .cassetieBox(item)
        }
        
        let finalSection = FinalSectionModel(model: .cassetieBox(items), items: items)
        
        return [finalSection]
    }
}

