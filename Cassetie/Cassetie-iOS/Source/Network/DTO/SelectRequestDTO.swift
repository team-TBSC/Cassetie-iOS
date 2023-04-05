//
//  SelectRequestDTO.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/04.
//

import Foundation

// MARK: - SelectedRequestDTO
struct SelectedRequestDTO: Codable {
    let name, song1ID, song2ID, song3ID: String
    let song3Search, song4ID, song4Search, song5ID: String
    let song5Search: String

    enum CodingKeys: String, CodingKey {
        case name
        case song1ID = "song1_id"
        case song2ID = "song2_id"
        case song3ID = "song3_id"
        case song3Search = "song3_search"
        case song4ID = "song4_id"
        case song4Search = "song4_search"
        case song5ID = "song5_id"
        case song5Search = "song5_search"
    }
}

struct SelectedMusicList {
    let selectMusic: MusicListDTO
    let isSelected: Bool
}
