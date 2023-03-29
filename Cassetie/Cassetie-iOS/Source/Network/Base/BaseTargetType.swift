//
//  BaseTargetType.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/28.
//

import UIKit

import Moya

protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: "http://digger.works:12023")!
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
