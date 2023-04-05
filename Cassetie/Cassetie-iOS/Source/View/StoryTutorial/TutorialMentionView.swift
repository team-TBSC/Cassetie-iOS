//
//  TutorialMentionView.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/06.
//

import UIKit

import SnapKit
import Then

enum TutorialType {
    case first
    case firstSub
    case second
    case third
    case fourth
    case fourthSub
    
    var text: String {
        switch self {
        case .first:
            return "여러분 안녕! 나는 여러분께 카세티아 행성 이야기를\n간략하게 설명할 카세티 1호야. 지금부터 눈 크게 뜨고 봐야된다 ?!"
        case .firstSub:
            return "먼 옛날.. \n카세티아 행성의 카세티는 지구 인류에게 음악을 가져다 주었어."
        case .second:
            return "카세티들은 한 몸 부서져라 음악 전파에 사명을 다했지 .."
        case .third:
            return "하지만 어디서나 음악을 보관하고 들을 수 있게된 인류는 카세티를 점점 잊게돼"
        case .fourth:
            return "생명을 잃고 묻혀있는 카세티들을 안타깝게 여긴 음악학자 세 명은 연구를 기반으로 '카센터 랩'이라는 이름으로 뭉치게 된다지"
        case .fourthSub:
            return "너도 우리 카센터 랩으로 구경오지 않을래?"
        }
    }
    
    var image: UIImage {
        switch self {
        case .first:
            return Image.tutorialFirstImg
        case .second:
            return Image.tutorialSecondImg
        case .third:
            return Image.tutorialThirdImg
        case .fourth:
            return Image.tutorialFourthImg
        case .firstSub, .fourthSub:
            return UIImage()
        }
    }
}

class TutorialMentionView: BaseView {
    let type: TutorialType
    
    private let backgroudView = UIImageView().then {
        $0.image = Image.tutorialMentionImg
    }
    
    private let mentionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 26, weight: .light)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let storyTellerLabel = UILabel().then {
        $0.text = "카세티 1호"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 28, weight: .bold)
    }
    
    init(type: TutorialType) {
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
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
        
        mentionLabel.snp.makeConstraints {
            $0.top.equalTo(storyTellerLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    override func setupProperty() {
        super.setupProperty()

        mentionLabel.text = type.text
        
        switch type {
        case .first, .firstSub, .fourth, .fourthSub:
            mentionLabel.textColor = .white
            storyTellerLabel.textColor = .white
        case .second, .third:
            mentionLabel.textColor = .gray
            storyTellerLabel.textColor = .gray
        }
    }
}
