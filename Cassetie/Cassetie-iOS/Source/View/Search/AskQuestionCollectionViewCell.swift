//
//  AskQuestionCollectionViewCell.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/03.
//

import UIKit

import SnapKit
import Then
import Gifu

enum QuestionType: CaseIterable {
    case first
    case second
    case third
    case fourth
    case fivth
    
    var firstText: String {
        switch self {
        case .first:
            return "당신의"
        case .second:
            return "당신의"
        case .third:
            return "당신을 가장 잘"
        case .fourth:
            return "당신이 가장"
        case .fivth:
            return "당신을"
        }
    }
    
    var secondText: String {
        switch self {
        case .first:
            return " 에너지"
        case .second:
            return " 감정"
        case .third:
            return " 표현하는"
        case .fourth:
            return " 좋아하는"
        case .fivth:
            return " 대표하는"
        }
    }
    
    var thirdText: String {
        switch self {
        case .first:
            return "를 표현하는 음악은?"
        case .second:
            return "을 표현하는 음악은?"
        case .third:
            return " 음악은?"
        case .fourth:
            return " 음악은?"
        case .fivth:
            return " 음악은?"
        }
    }
    
    var subText: String {
        switch self {
        case .first:
            return "감정"
        case .second:
            return "텐션"
        case .third:
            return "외형"
        case .fourth:
            return "커스텀"
        case .fivth:
            return "대표 노래"
        }
    }
    
    var gifImage: String {
        switch self {
        case .first:
            return "cassetie-first"
        case .second:
            return "cassetie-second"
        case .third:
            return "cassetie-third"
        case .fourth:
            return "cassetie-fourth"
        case .fivth:
            return "cassetie-fivth"
        }
    }
}

class AskQuestionCollectionViewCell: BaseCollectionViewCell {
    
    var questionType: QuestionType = .first
    
    lazy var questionLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    var cassetieGifImageView = GIFImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let subTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .light)
        $0.textColor = .white.withAlphaComponent(0.5)
    }
    
    override func setupLayout() {
        super.setupLayout()
       
        cassetieGifImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(334.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(257.adjustedHeight)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(cassetieGifImageView.snp.bottom).offset(5.adjustedHeight)
            $0.centerX.equalToSuperview()
        }
        
        subTextLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([cassetieGifImageView, questionLabel, subTextLabel])
    }
    
    func configure(_ type: QuestionType) {
        questionLabel.attributedText = NSMutableAttributedString()
            .regular(string: type.firstText, fontSize: 28)
            .bold(string: type.secondText, fontSize: 28)
            .regular(string: type.thirdText, fontSize: 28)
        
        cassetieGifImageView.animate(withGIFNamed: type.gifImage)
        
        subTextLabel.text = type.subText
    }
}
