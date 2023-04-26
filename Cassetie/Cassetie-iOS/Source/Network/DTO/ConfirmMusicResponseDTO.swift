//
//  ConfirmMusicResponseDTO.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/26.
//

import Foundation

struct ConfirmMusicResponseDTO: Codable, Equatable {
    let cassettiInfo: CassettiInfo

    enum CodingKeys: String, CodingKey {
        case cassettiInfo = "cassetti_info"
    }

    static func ==(lhs: ConfirmMusicResponseDTO, rhs: ConfirmMusicResponseDTO) -> Bool {
        return lhs.cassettiInfo == rhs.cassettiInfo
    }
    
    init() {
        self.cassettiInfo = CassettiInfo(name: String(), energy: Int(), emotion: Int(), genre1: Int(), genre2: Int(), genre3: Int())
    }
}

struct CassettiInfo: Codable, Equatable {
    let name: String
    let energy, emotion, genre1, genre2: Int
    let genre3: Int

    static func ==(lhs: CassettiInfo, rhs: CassettiInfo) -> Bool {
        return lhs.name == rhs.name &&
            lhs.energy == rhs.energy &&
            lhs.emotion == rhs.emotion &&
            lhs.genre1 == rhs.genre1 &&
            lhs.genre2 == rhs.genre2 &&
            lhs.genre3 == rhs.genre3
    }
}





