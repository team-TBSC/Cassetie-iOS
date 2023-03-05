//
//  MusicPreviewCollectionViewCell.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/02/27.
//

import UIKit

import SnapKit
import Then

class MusicPreviewCollectionViewCell: BaseCollectionViewCell {
    private let albumCoverImage = UIImageView().then {
        $0.cornerRound(radius: 5)
    }
    
    private let titleLable = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private let singerLable = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private let musicDetailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        albumCoverImage.snp.makeConstraints {
            $0.width.equalTo(92.adjustedWidth)
            $0.height.equalTo(92.adjustedWidth)
            $0.leading.equalToSuperview().offset(13)
            $0.centerY.equalToSuperview()
        }
        
        musicDetailStackView.snp.makeConstraints {
            $0.leading.equalTo(albumCoverImage.snp.trailing).offset(20.adjustedWidth)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()

        musicDetailStackView.addArrangedSubviews([titleLable, singerLable])
        addSubviews([albumCoverImage, musicDetailStackView])
    }
    
    func configure(_ model: MusicPreviewModel) {
        self.albumCoverImage.image = model.albumImage
        self.titleLable.text = model.title
        self.singerLable.text = model.singer
    }
}

