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
    
    init() {
        self.name = String()
        self.song3Search = String()
        self.song4Search = String()
        self.song5Search = String()
        self.song1ID = String()
        self.song2ID = String()
        self.song3ID = String()
        self.song4ID = String()
        self.song5ID = String()
    }
    
    init(name: String, song1ID: String, song2ID: String, song3ID: String, song3Search: String, song4ID: String, song4Search: String, song5ID: String, song5Search: String) {
        self.name = name
        self.song3Search = song3Search
        self.song4Search = song4Search
        self.song5Search = song5Search
        self.song1ID = song1ID
        self.song2ID = song2ID
        self.song3ID = song3ID
        self.song4ID = song4ID
        self.song5ID = song5ID
    }
}

struct SelectedMusicList {
    let selectMusic: MusicListDTO
    let isSelected: Bool
}
