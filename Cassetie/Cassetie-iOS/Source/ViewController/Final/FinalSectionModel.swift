//
//  FinalSectionModel.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/21.
//

import Foundation

import RxDataSources

typealias FinalSectionModel = SectionModel<FinalSection, FinalItem>

struct FinalTestModel {
    let text: String
    
    init(text: String) {
        self.text = text
    }
}

enum FinalSection {
    case cassetieBox([FinalItem])
}

enum FinalItem {
    case cassetieBox(FinalTestModel)
}

extension FinalSection: SectionModelType {
    typealias Item = FinalItem
    
    var items: [Item] {
        switch self {
        case let .cassetieBox(items):
            return items
        }
    }
    
    init(original: FinalSection, items: [FinalItem]) {
        switch original {
        case let .cassetieBox(items):
            self = .cassetieBox(items)
        }
    }
}

