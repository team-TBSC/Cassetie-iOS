//
//  StoryTutorialViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/16.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxGesture

class FirstStoryTutorialViewController: BaseViewController {
    private let tutorialImageView = UIImageView().then {
        $0.image = Image.tutorialFirstImg
        $0.contentMode = .scaleAspectFill
    }
    
    private let firstMentionView = TutorialMentionView(type: .first)
    private let secondMentionView = TutorialMentionView(type: .firstSub)
    private var switchFlag: Bool = false
    private let tapGesture = UITapGestureRecognizer()
    
    override func setupLayout() {
        super.setupLayout()
        
        tutorialImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalToSuperview()
            $0.leading.equalToSuperview().inset(230)
        }
        
        firstMentionView.snp.makeConstraints {
            $0.width.equalTo(713.adjustedWidth)
            $0.height.equalTo(245.adjustedHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(70)
        }
        
        secondMentionView.snp.makeConstraints {
            $0.width.equalTo(713.adjustedWidth)
            $0.height.equalTo(250.adjustedHeight)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(65)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([tutorialImageView, firstMentionView, secondMentionView])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        secondMentionView.isHidden = true
        view.addGestureRecognizer(tapGesture)
    }
    
    override func setupBind() {
        super.setupBind()
        
        tapGesture.rx.event
            .subscribe(onNext: { _ in
                if self.switchFlag {
                    let secondStoryTutorialViewController = SecondStoryTutorialViewController()
                    self.navigationController?.pushViewController(secondStoryTutorialViewController, animated: false)
                } else {
                    self.firstMentionView.isHidden = true
                    self.remakeLayout()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func remakeLayout() {
        UIView.animate(withDuration: 4.0) {
            let scale = CGAffineTransform(translationX: -490, y:0)
            self.tutorialImageView.transform = scale
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.5) {
            self.secondMentionView.isHidden = false
            self.switchFlag = true
        }
    }
}
