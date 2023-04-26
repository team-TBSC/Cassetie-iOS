//
//  FinalEndPoint.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/27.
//

import UIKit

import Moya

enum FinalEndPoint {
    case get
}

extension FinalEndPoint: EndPoint {
    var path: String {
        switch self {
        case .get:
            return "/getDB/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .get:
            return .requestPlain
        }
    }
}
