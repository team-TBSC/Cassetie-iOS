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
    case updateSelectedMusicList([MusicListDTO], String, String, String) // MARK: - 음악 선택된 경우 List update
    case completeCassetie(data: ConfirmMusicResponseDTO)
}

protocol ConfirmMusicServiceType {
    var event: PublishSubject<ConfirmMusicEvent> { get }
    
    func post(data: SelectedRequestDTO)
}

class ConfirmMusicService: BaseService, ConfirmMusicServiceType, APIProvider {
    typealias Target = ConfirmEndPoint
    
    var event = PublishSubject<ConfirmMusicEvent>()
    let disposedBag = DisposeBag()
    
    func post(data: SelectedRequestDTO) {
        ConfirmMusicService.request(endPoint: ConfirmEndPoint.post(data: data))
            .bind { [weak self] (data: ConfirmMusicResponseDTO) in
                self?.event.onNext(.completeCassetie(data: data))
            }
            .disposed(by: disposedBag)
    }
}
