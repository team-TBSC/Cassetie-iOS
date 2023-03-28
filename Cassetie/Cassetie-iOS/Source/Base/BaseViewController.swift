//
//  BaseViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/01/09.
//

import UIKit

import RxSwift
import RxCocoa

class BaseViewController: UIViewController, BaseViewProtocol {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupProperty()
        setupDelegate()
        setupHierarchy()
        setupLayout()
        setupBind()
    }

    func setupProperty() { }
    
    func setupDelegate() { }
    
    func setupHierarchy() { }
    
    func setupLayout() { }
    
    func setupBind() { }
}

extension BaseViewController {
    @objc func keyboardWillShow(height: CGFloat) {}
    
    @objc func keyboardWillHide() {}
    
    func setKeyboardNotification() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .withUnretained(self)
            .bind { (this, notification) in
                let height = this.keyboardHeight(notification: notification)
                this.keyboardWillShow(height: height)
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .withUnretained(self)
            .bind { (this, notification) in
                this.keyboardWillHide()
            }
            .disposed(by: disposeBag)
    }
    
    private func keyboardHeight(notification: Notification) -> CGFloat {
        let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardFrame.cgRectValue.height
    }
}

