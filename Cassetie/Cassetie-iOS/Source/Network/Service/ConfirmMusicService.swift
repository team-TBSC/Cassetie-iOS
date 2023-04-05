//
//  ConfirmMusicService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/06.
//

import UIKit

import Moya
import RxSwift

enum ConfirmMusicEvent {
    case updateSelectedMusicList([MusicListDTO])
}

protocol ConfirmMusicServiceType {
    var event: PublishSubject<ConfirmMusicEvent> { get }
}

class ConfirmMusicService: BaseService, ConfirmMusicServiceType {
    var event = PublishSubject<ConfirmMusicEvent>()
    let disposedBag = DisposeBag()
}
