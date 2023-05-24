//
//  CompletedCassetieViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/27.
//

import UIKit

import SnapKit
import Then

enum CassetieType: Int, CaseIterable {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case defaultNum = 10
    
    var image: UIImage {
        switch self {
        case .zero:
            return Image.cassetieRock
        case .one:
            return Image.cassetieBallad
        case .two:
            return Image.cassetieIndie
        case .three:
            return Image.cassetieTrot
        case .four:
            return Image.cassetieHiphop
        case .five:
            return Image.cassetieDance
        case .six:
            return Image.cassetiePop
        case .seven, .eight, .defaultNum:
            return Image.cassetieUndefined
        }
    }
    
    var genre: String {
        switch self {
        case .zero:
            return "락/메탈"
        case .one:
            return "발라드"
        case .two:
            return "인디/어쿠스틱"
        case .three:
            return "트로트"
        case .four:
            return "힙합/R&B"
        case .five:
            return "댄스"
        case .six:
            return "POP"
        case .seven, .eight, .defaultNum:
            return "기타"
        }
    }
}

class CompletedCassetieViewController: BaseViewController {
    var completedCassetie: ConfirmMusicResponseDTO?
    
    lazy var type: CassetieType = CassetieType.allCases.filter { $0.rawValue == completedCassetie?.cassettiInfo.genre1 }.first ?? .defaultNum
    
    let backgroundView = UIImageView().then {
        $0.image = Image.backgroundImg
    }
    
    let backgroundStarImg = UIImageView().then {
        $0.image = Image.backgroundStarImg
    }
    
    lazy var cassetieImage = UIImageView().then {
        $0.image = type.image
    }
    
    let cassetieNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 50, weight: .bold)
        $0.textColor = .white
    }
    
    let textLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .light)
        $0.textColor = .gray
    }
    
    let goBackButton = RoundButton(title: "돌아가기", titleColor: .black, backColor: .white, round: 40).then {
        $0.configureFont(font: .systemFont(ofSize: 24, weight: .light))
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundStarImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cassetieImage.snp.makeConstraints {
            $0.width.height.equalTo(650.adjustedWidth)
            $0.top.equalToSuperview().offset(170.adjustedHeight)
            $0.centerX.equalToSuperview()
        }
        
        cassetieNameLabel.snp.makeConstraints {
            $0.top.equalTo(cassetieImage.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(cassetieNameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        goBackButton.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp.bottom).offset(100)
            $0.width.equalTo(245)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        goBackButton.rx.tap
            .bind(onNext: { [weak self] in
                let startViewController = StartViewController()
                self?.navigationController?.pushViewController(startViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        guard let cassetieInfo = completedCassetie else { return }
        cassetieNameLabel.text = cassetieInfo.cassettiInfo.name
        textLabel.text = "\"" + cassetieInfo.cassettiInfo.text + "\""
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, backgroundStarImg, cassetieImage, cassetieNameLabel, textLabel, goBackButton])
    }
}
