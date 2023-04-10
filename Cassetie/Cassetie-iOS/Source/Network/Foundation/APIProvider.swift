//
//  Networkable.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/28.
//

import UIKit

import RxSwift
import Moya


protocol APIProvider {
    associatedtype Target: EndPoint
}

extension APIProvider {
    static func request<T: Decodable>(endPoint: EndPoint) -> Observable<T> {
        return Observable<T>.create { creater in
            MoyaProvider<Target>(plugins: [NetworkLoggerPlugin()]).request(endPoint as! Self.Target) { result in
                switch result {
                case .success(let response):
                    guard let jsonString = String(data: response.data, encoding: .utf8) else { return creater.onError(APIError.jsonParsingError) }
                    let decoder = JSONDecoder()
                    if let data = try? decoder.decode(T.self, from: jsonString.data(using: .utf8) ?? Data()) {
                        creater.onNext(data)
                    }
                case .failure(let error):
                    creater.onError(error)
                }
                creater.onCompleted()
            }
            return Disposables.create()
        }
    }
}
