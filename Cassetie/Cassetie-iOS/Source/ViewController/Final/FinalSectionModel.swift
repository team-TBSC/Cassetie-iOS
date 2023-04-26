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
    let name: String
    let genre: Int
    let cassetieType: Int
    
    init(name: String , genre: Int, cassetieType: Int) {
        self.genre = genre
        self.name = name
        self.cassetieType = cassetieType
    }
}

enum FinalSection {
    case cassetieBox([FinalItem])
}

enum FinalItem {
    case cassetieBox(CassetieInfoDTO)
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

