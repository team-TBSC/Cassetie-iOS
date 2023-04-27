//
//  LoadingService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/27.
//

import UIKit

import RxSwift

enum LoadingEvent {
    case getCassetieInfo(data: ConfirmMusicResponseDTO)
}

protocol LoadingServiceType {
    var event: PublishSubject<LoadingEvent> { get }
}

class LoadingService: BaseService, LoadingServiceType {
    var event = PublishSubject<LoadingEvent>()
    let disposedBag = DisposeBag()
}
    
