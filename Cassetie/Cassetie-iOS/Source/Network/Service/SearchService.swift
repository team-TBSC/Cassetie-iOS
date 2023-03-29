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
}

protocol SearchServiceType {
    var event: PublishSubject<SearchEvent> { get }
    
//    func post(text: String) -> Observable<SearchResponseDTO>
}

class SearchService: SearchServiceType, Networkable {
    var event = PublishSubject<SearchEvent>()
    let disposedBag = DisposeBag()
    
    typealias ResponseType = SearchResponseDTO
    typealias Target = SearchEndPoint
    
//    func post(text: String) -> Observable<SearchResponseDTO> {
//        print("------- Search Service -------- ")
//
//        return Observable<SearchResponseDTO>.create { creater in
//            print("------- observable --------")
//            SearchService.makeProvider().request(.post(text: "after")) { result in
//                guard self != nil else { return }
//
//                switch result {
//                case .success(let response):
//                    print("------------ response ------------")
//                    print(response)
//                    do {
//                        let data = try JSONDecoder().decode(SearchResponseDTO.self, from: response.data)
//                        creater.onNext(data)
//                    } catch(let err) {
//                        print("---------------- err ------------")
//                        print(err.localizedDescription)
//                        creater.onError(err)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    creater.onError(error)
//                }
//                creater.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
    
    func testPost(text: String) {
        SearchService.request(endPoint: SearchEndPoint.post(text: text))
            .bind { [weak self] data in
                print("-------- 🙅🏻‍♀️ testPost --------")
                self?.event.onNext(.postMusicList(data))
            }
            .disposed(by: disposedBag)
    }
}
    
