//
//  FinalResponseDTO.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/27.
//

import UIKit

// MARK: - FinalResponseDTO
struct FinalResponseDTO: Codable {
    let dbData: [CassetieInfoDTO]

    enum CodingKeys: String, CodingKey {
        case dbData = "db_data"
    }
}

// MARK: - CassetieInfoDTO
struct CassetieInfoDTO: Codable {
    let name, num, text: String
    let song1, song2, song3, song4, song5: Song
}

// MARK: - Song
struct Song: Codable {
    let track, artist: String
    let image: String
}
