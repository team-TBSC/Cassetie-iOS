//
//  Networkable.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/28.
//

import UIKit

import RxSwift
import Moya


protocol Networkable {
    associatedtype Target: BaseTargetType
    associatedtype ResponseType: Codable
}

extension Networkable {
    static func request(endPoint: BaseTargetType) -> Observable<ResponseType> {
        return Observable<ResponseType>.create { creater in
            print("------- observable --------")
            MoyaProvider<Target>(plugins: [NetworkLoggerPlugin()]).request(endPoint as! Self.Target) { result in
                //                guard self != nil else { return }
                
                switch result {
                case .success(let response):
                    print("------------ response ------------")
                    print(response)
                    do {
                        let data = try JSONDecoder().decode(ResponseType.self, from: response.data)
                        creater.onNext(data)
                    } catch(let err) {
                        print("---------------- err ------------")
                        print(err.localizedDescription)
                        creater.onError(err)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    creater.onError(error)
                }
                creater.onCompleted()
            }
            return Disposables.create()
        }
    }
}
