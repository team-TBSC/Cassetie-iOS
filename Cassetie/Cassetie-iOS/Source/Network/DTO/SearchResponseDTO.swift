//
//  SearchResponseDTO.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/28.
//

import Foundation

// MARK: - SearchResponseDTO
struct SearchResponseDTO: Codable {
    let musicList: [MusicListDTO]

    enum CodingKeys: String, CodingKey {
        case musicList = "music_list"
    }
}

// MARK: - MusicList
struct MusicListDTO: Codable {
    let track, artist, album: String
    let image: String
    let previewURL: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case track, artist, album, image
        case previewURL = "preview_url"
        case id
    }
}

