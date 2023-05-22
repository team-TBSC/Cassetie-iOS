//
//  InfoReactor.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/05/21.
//

import UIKit

import ReactorKit

class InfoReactor: Reactor {
    enum Action {
        case post
        case updateName(String)
        case updateMentionText(String)
    }
    
    enum Mutation {
        case updateName(String)
        case updateMentionText(String)
    }
    
    struct State {
        var name: String = String()
        var mentionText: String = String()
    }
    
    var initialState: State
    var selectedRequestData: SelectedRequestDTO = SelectedRequestDTO.init()
    
    init() {
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = NetworkService.shared.info.event
            .flatMap({ (event) -> Observable<Mutation> in
                switch event {
                case let .update(data):
                    self.selectedRequestData = data
                    return .empty()
                }
            })
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .post:
            self.selectedRequestData.name = currentState.name
            self.selectedRequestData.text = currentState.mentionText
            
            NetworkService.shared.confirm.post(data: selectedRequestData)
            return .empty()
        case let .updateName(name):
            return .just(.updateName(name))
        case let .updateMentionText(text):
            return .just(.updateMentionText(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateName(name):
            newState.name = name
        case let .updateMentionText(text):
            newState.mentionText = text
        }
        
        return newState
    }
}
