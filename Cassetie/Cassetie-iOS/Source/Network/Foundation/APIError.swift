//
//  APIError.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/30.
//

import Foundation

enum APIError: Error {
    case urlEncodingError
    case jsonParsingError
    case clientError(error: String)
    case serverError(error: String)
}
