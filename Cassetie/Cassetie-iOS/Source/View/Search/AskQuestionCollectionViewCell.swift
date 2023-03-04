//
//  AskQuestionCollectionViewCell.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/03.
//

import UIKit

import SnapKit
import Then

enum QuestionType: CaseIterable {
    case first
    case second
    case third
    case fourth
    case fivth
    
    var text: String {
        switch self {
        case .first:
            return "슬플 때"
        case .second:
            return "화날 때"
        case .third:
            return "기분 좋을 때"
        case .fourth:
            return "착잡할 때"
        case .fivth:
            return "나른할 때"
        }
    }
    
    var image: UIImage {
        return Image.testCassetieImage
    }
}

class AskQuestionCollectionViewCell: BaseCollectionViewCell {
    
    var questionType: QuestionType = .first
    
    lazy var questionLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    var cassetieImage = UIImageView()
    
    override func setupLayout() {
        super.setupLayout()
       
        cassetieImage.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(50)
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(334)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(257)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(cassetieImage.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([cassetieImage, questionLabel])
    }
    
    func configure(_ type: QuestionType) {
        questionLabel.attributedText = NSMutableAttributedString()
            .regular(string: "소진님이 ", fontSize: 28)
            .bold(string: type.text, fontSize: 28)
            .regular(string: " 듣는 노래는?", fontSize: 28)
        cassetieImage.image = type.image
    }
}
