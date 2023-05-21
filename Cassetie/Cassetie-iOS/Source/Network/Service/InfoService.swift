//
//  InfoService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/05/21.
//

import UIKit

import RxSwift

enum InfoEvent {
    case update(data: SelectedRequestDTO)
}

protocol InfoServiceType {
    var event: PublishSubject<InfoEvent> { get }
}

class InfoService: BaseService, InfoServiceType {
    var event = PublishSubject<InfoEvent>()
    let disposedBag = DisposeBag()
}
    
