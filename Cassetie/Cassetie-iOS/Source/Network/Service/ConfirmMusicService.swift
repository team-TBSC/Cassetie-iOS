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
    case updateSelectedMusicList([MusicListDTO], String, String, String)
}

protocol ConfirmMusicServiceType {
    var event: PublishSubject<ConfirmMusicEvent> { get }
    
    func post(data: SelectedRequestDTO)
}

class ConfirmMusicService: BaseService, ConfirmMusicServiceType, APIProvider {
    typealias Target = ConfirmEndPoint
    typealias ResponseType = SelectedRequestDTO
    
    var event = PublishSubject<ConfirmMusicEvent>()
    let disposedBag = DisposeBag()
    
    func post(data: SelectedRequestDTO) {
        ConfirmMusicService.request(endPoint: ConfirmEndPoint.post(data: data))
            .bind { [weak self] data in
                print(data)
            }
            .disposed(by: disposedBag)
    }
}
