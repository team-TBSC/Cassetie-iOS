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
    associatedtype ResponseType: Codable
}

extension APIProvider {
    static func request(endPoint: EndPoint) -> Observable<ResponseType> {
        return Observable<ResponseType>.create { creater in
            MoyaProvider<Target>(plugins: [NetworkLoggerPlugin()]).request(endPoint as! Self.Target) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try JSONDecoder().decode(ResponseType.self, from: response.data)
                        creater.onNext(data)
                    } catch(let err) {
                        print(err)
                        creater.onError(APIError.jsonParsingError)
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
