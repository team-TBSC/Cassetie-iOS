//
//  BaseView.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/01/09.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol BaseViewProtocol {
    func setupProperty()
    func setupDelegate()
    func setupHierarchy()
    func setupLayout()
    func setupBind()
}

class BaseView: UIView, BaseViewProtocol {
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProperty()
        setupDelegate()
        setupHierarchy()
        setupLayout()
        setupBind()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    func setupProperty() { }
    
    func setupDelegate() { }
    
    func setupHierarchy() { }
    
    func setupLayout() { }
    
    func setupBind() { }
}

