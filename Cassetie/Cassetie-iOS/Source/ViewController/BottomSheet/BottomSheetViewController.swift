//
//  BottomSheetViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/06.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxGesture

class BottomSheetViewController: BaseViewController {
    private let backgroundView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = Color.navyD
        $0.cornerRound(radius: 40, direct: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
    }
    
    let bottomSheetHeight: CGFloat = 720.adjustedHeight
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearBottomSheet()
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        self.view.backgroundColor = .clear
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.adjustedHeight)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, bottomSheetView])
    }
    
    override func setupBind() {
        super.setupBind()
        
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { this, gesture in
                self.disappearBottomSheet()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    this.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        bottomSheetView.rx.panGesture()
            .withUnretained(self)
            .bind { this, gesture in
                let translation = gesture.translation(in: self.backgroundView)
                
                guard translation.y > 0 else { return }
                
                switch gesture.state {
                case .ended:
                    if translation.y > self.bottomSheetHeight / 2 {
                        this.dismiss(animated: true)
                    } else {
                        self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: 0)
                    }
                case .changed:
                    self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showBottomSheet() {
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(720.adjustedHeight)
        }
        
        UIView.animate(
            withDuration: 0.5,
            animations: self.view.layoutIfNeeded
        )
    }
    
    private func disappearBottomSheet() {
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.adjustedHeight)
        }
        
        UIView.animate(
            withDuration: 0.5,
            animations: self.view.layoutIfNeeded
        )
    }
}
