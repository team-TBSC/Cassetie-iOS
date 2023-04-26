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

// MARK: - DBDatum
struct CassetieInfoDTO: Codable {
    let name, num: String
    
}
