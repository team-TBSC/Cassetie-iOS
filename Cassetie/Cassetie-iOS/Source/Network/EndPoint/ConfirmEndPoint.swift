//
//  ConfirmEndPoint.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/09.
//

import UIKit

import Moya

enum ConfirmEndPoint {
    case post(data: SelectedRequestDTO)
}

extension ConfirmEndPoint: EndPoint {
    var path: String {
        switch self {
        case .post:
            return "/getCstInfo/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .post:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case let .post(data):
            return .requestParameters(
                parameters: [
                    "name" : data.name,
                    "song1_id": data.song1ID,
                    "song2_id": data.song2ID,
                    "song3_id": data.song3ID,
                    "song3_search": data.song3Search,
                    "song4_id": data.song4ID,
                    "song4_search": data.song4Search,
                    "song5_id": data.song5ID,
                    "song5_search": data.song5Search,
                ], encoding: JSONEncoding.default)
        }
    }
}
