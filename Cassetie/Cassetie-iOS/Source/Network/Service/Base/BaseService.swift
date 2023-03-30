//
//  BaseService.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/30.
//

import UIKit

import RxSwift

protocol BaseServiceType {
    var disposeBag: DisposeBag { get }
}

class BaseService: BaseServiceType {
    var disposeBag: DisposeBag = .init()
    
    init() {
        
    }
}
