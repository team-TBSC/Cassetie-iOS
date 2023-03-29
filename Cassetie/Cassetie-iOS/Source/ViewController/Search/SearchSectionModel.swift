//
//  SearchSectionModel.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/02/27.
//

import Foundation

import RxDataSources

typealias SearchSectionModel = SectionModel<SearchSection, SearchItem>

struct MusicPreviewModel {
    let albumImage: UIImage
    let title: String
    let singer: String
    
    init(albumImage: UIImage = .init(), title: String = .init(), singer: String = .init()) {
        self.albumImage = albumImage
        self.title = title
        self.singer = singer
    }
}

enum SearchSection {
    case musicPreview([SearchItem])
}

enum SearchItem {
    case musicPreview(MusicListDTO)
}

extension SearchSection: SectionModelType {
    typealias Item = SearchItem
    
    var items: [Item] {
        switch self {
        case let .musicPreview(items):
            return items
        }
    }
    
    init(original: SearchSection, items: [SearchItem]) {
        switch original {
        case let .musicPreview(items):
            self = .musicPreview(items)
        }
    }
}

