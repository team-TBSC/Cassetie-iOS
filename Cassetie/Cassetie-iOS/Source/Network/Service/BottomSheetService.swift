//
//  BottomSheetService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/05.
//

import UIKit

import Moya
import RxSwift

enum BottomSheetEvent {
    case selectMusic
}

protocol BottomSheetServiceType {
    var event: PublishSubject<BottomSheetEvent> { get }
}

class BottomSheetService: BaseService, BottomSheetServiceType {
    var event = PublishSubject<BottomSheetEvent>()
    let disposedBag = DisposeBag()
}
    
