//
//  NetworkService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/05.
//

final class NetworkService {
    static let shared = NetworkService()
    
    let search = SearchService()
    let bottomSheet = BottomSheetService()
    let confirm = ConfirmMusicService()
}
