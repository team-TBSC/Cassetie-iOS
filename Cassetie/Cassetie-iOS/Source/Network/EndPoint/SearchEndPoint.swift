//
//  SearchEndPoint.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/28.
//

import UIKit

import Moya

enum SearchEndPoint {
    case post(text: String)
}

extension SearchEndPoint: EndPoint {
    var path: String {
        switch self {
        case .post:
            return "/getMusicList/"
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
        case let .post(text):
            return .requestParameters(
                parameters: [
                    "track" : text
                ], encoding: JSONEncoding.default)
        }
    }
}
