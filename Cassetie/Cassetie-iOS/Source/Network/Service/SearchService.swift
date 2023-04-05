//
//  SearchService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/28.
//

import UIKit

import Moya
import RxSwift

enum SearchEvent {
    case postMusicList(SearchResponseDTO)
    case updateSelectedMusicList(MusicListDTO, Int)
}

protocol SearchServiceType {
    var event: PublishSubject<SearchEvent> { get }
    
    func post(text: String)
}

class SearchService: BaseService, SearchServiceType, APIProvider {
    typealias Target = SearchEndPoint
    typealias ResponseType = SearchResponseDTO
    
    var event = PublishSubject<SearchEvent>()
    let disposedBag = DisposeBag()
    
    func post(text: String) {
        SearchService.request(endPoint: SearchEndPoint.post(text: text))
            .bind { [weak self] data in
                self?.event.onNext(.postMusicList(data))
            }
            .disposed(by: disposedBag)
    }
}
    
