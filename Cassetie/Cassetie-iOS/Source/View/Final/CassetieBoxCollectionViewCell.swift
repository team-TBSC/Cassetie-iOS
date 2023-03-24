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
    
    let cassetieImage = UIImageView().then {
        $0.image = Image.testCassetieImg
    }
    
    let nameLabel = UILabel().then {
        $0.text = "카세티 2호"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 36, weight: .bold)
    }
    
    let genreLabel = UILabel().then {
        $0.text = "POP"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 28, weight: .regular)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        cassetieContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cassetieImage.snp.makeConstraints {
            $0.width.equalTo(374)
            $0.height.equalTo(437)
            $0.top.equalToSuperview().offset(55.adjustedHeight)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(cassetieImage.snp.bottom).offset(40)
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
}
