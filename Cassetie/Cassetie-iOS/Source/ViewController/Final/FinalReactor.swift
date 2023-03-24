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
            return .just(.setFinalSection(createSection()))
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
    
    func createSection() -> [FinalSectionModel] {
        let dummyData: [FinalTestModel] = [
            FinalTestModel(text: "첫 번째 카세티"),
            FinalTestModel(text: "두 번째 카세티"),
            FinalTestModel(text: "세 번째 카세티")
        ]
        
        let items: [FinalItem] = dummyData.map { item in
            return .cassetieBox(item)
        }
        
        let finalSection = FinalSectionModel(model: .cassetieBox(items), items: items)
        
        return [finalSection]
    }
}
