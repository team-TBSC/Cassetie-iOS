//
//  FinalService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/27.
//

import UIKit

import Moya
import RxSwift

enum FinalEvent {
    case updateAllCassetie(data: FinalResponseDTO)
}

protocol FinalServiceType {
    var event: PublishSubject<FinalEvent> { get }
    
    func get()
}

class FinalService: BaseService, FinalServiceType, APIProvider {
    typealias Target = FinalEndPoint
    
    var event = PublishSubject<FinalEvent>()
    let disposedBag = DisposeBag()
    
    func get() {
        FinalService.request(endPoint: FinalEndPoint.get)
            .bind { [weak self] (data: FinalResponseDTO) in
                self?.event.onNext(.updateAllCassetie(data: data))
            }
            .disposed(by: disposedBag)
    }
}

