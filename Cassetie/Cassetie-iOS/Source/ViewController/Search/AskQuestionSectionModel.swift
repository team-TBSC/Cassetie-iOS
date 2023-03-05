//
//  AskQuestionSectionModel.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/04.
//

import Foundation

import RxDataSources

typealias AskQuestionSectionModel = SectionModel<AskQuestionSection, AskQuestionItem>

enum AskQuestionSection {
    case askQuestion([AskQuestionItem])
}

enum AskQuestionItem {
    case askQuestion(QuestionType)
}

extension AskQuestionSection: SectionModelType {
    typealias Item = AskQuestionItem
    
    var items: [Item] {
        switch self {
        case let .askQuestion(items):
            return items
        }
    }
    
    init(original: AskQuestionSection, items: [AskQuestionItem]) {
        switch original {
        case let .askQuestion(items):
            self = .askQuestion(items)
        }
    }
}

