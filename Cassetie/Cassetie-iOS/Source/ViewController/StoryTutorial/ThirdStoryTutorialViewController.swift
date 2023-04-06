//
//  ThirdStoryTutorialViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/06.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxGesture

class ThirdStoryTutorialViewController: BaseViewController {
    private let tutorialImageView = UIImageView().then {
        $0.image = Image.tutorialThirdImg
        $0.contentMode = .scaleAspectFill
    }
    
    private let mentionView = TutorialMentionView(type: .third)
    var switchFlag: Bool = false
    
    override func setupLayout() {
        super.setupLayout()
        
        tutorialImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalToSuperview()
            $0.leading.equalToSuperview().inset(230)
        }
        
        mentionView.snp.makeConstraints {
            $0.width.equalTo(713.adjustedWidth)
            $0.height.equalTo(245.adjustedHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(70)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([tutorialImageView, mentionView])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        mentionView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.remakeLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func setupBind() {
        super.setupBind()
        
        tutorialImageView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: {_ in
                let fourthStoryTutorialViewController = FourthStoryTutorialViewController()
                self.navigationController?.pushViewController(fourthStoryTutorialViewController, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    func remakeLayout() {
        UIView.animate(withDuration: 4.0) {
            let scale = CGAffineTransform(translationX: -490, y:0)
            self.tutorialImageView.transform = scale
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.5) {
            self.mentionView.isHidden = false
        }
    }
}

