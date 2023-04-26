//
//  CassetieBoxCollectionViewCell.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/21.
//

import UIKit

import SnapKit
import Then

class CassetieBoxCollectionViewCell: BaseCollectionViewCell {
    let cassetieContainerView = UIImageView().then {
        $0.image = Image.cassetieContainerImg
    }
    
    let cassetieImage = UIImageView()
    
    let nameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    let genreLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 28, weight: .light)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        cassetieContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cassetieImage.snp.makeConstraints {
            $0.width.height.equalTo(450.adjustedWidth)
            $0.top.equalToSuperview().offset(55.adjustedHeight)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(cassetieImage.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([cassetieContainerView, cassetieImage, nameLabel, genreLabel])
    }
    
    func configure(_ model: CassetieInfoDTO) {
        let type: CassetieType = CassetieType.allCases.filter { $0.rawValue == Int(model.num) }.first ?? .defaultNum
        
        self.nameLabel.text = model.name
        self.genreLabel.text = type.genre
        self.cassetieImage.image = type.image
    }
}
