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

enum MentionType {
    case first
    case second
    
    var text: String {
        switch self {
        case .first:
            return "하하 안녕하세요 첫 번째 튜토리얼입니다. 저 힘들어요 찡찡~"
        case .second:
            return "멘트를 알려주었으면 좋겠습니다"
        }
    }
}

class TutorialMentionView: BaseView {
    let type: MentionType
    
    private let backgroudView = UIImageView().then {
        $0.image = Image.tutorialMentionImg
    }
    
    private let mentionLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 24, weight: .light)
    }
    
    private let storyTellerLabel = UILabel().then {
        $0.text = "찐세티"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 28, weight: .bold)
    }
    
    init(type: MentionType) {
        self.type = type
        
        super.init(frame: .zero)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([backgroudView, storyTellerLabel, mentionLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroudView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        storyTellerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.leading.equalToSuperview().offset(50)
        }
        
        mentionLabel.snp.makeConstraints {
            $0.top.equalTo(storyTellerLabel.snp.bottom).offset(16)
            $0.leading.equalTo(storyTellerLabel.snp.leading)
        }
    }
    
    override func setupProperty() {
        super.setupProperty()

        mentionLabel.text = type.text
    }
}

class StoryTutorialViewController: BaseViewController {
    private let tutorialImageView = UIImageView().then {
        $0.image = Image.tutorialImg
        $0.contentMode = .scaleAspectFill
    }
    
    private let firstMentionView = TutorialMentionView(type: .first)
    
    override func setupLayout() {
        super.setupLayout()
        
        tutorialImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalToSuperview()
            $0.leading.equalToSuperview().inset(230)
        }
        
        firstMentionView.snp.makeConstraints {
            $0.width.equalTo(713.adjustedWidth)
            $0.height.equalTo(255.adjustedHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(70)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([tutorialImageView, firstMentionView])
    }
    
    override func setupBind() {
        super.setupBind()
        
        tutorialImageView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: {_ in
                self.firstMentionView.isHidden = true
                self.remakeLayout()
            })
            .disposed(by: disposeBag)
    }
    
    func remakeLayout() {
        UIView.animate(withDuration: 5.0) {
            let scale = CGAffineTransform(translationX: -490, y:0)
            self.tutorialImageView.transform = scale
        }
    }
}
