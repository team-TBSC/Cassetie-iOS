//
//  EmptyMusicCollectionViewCell.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/30.
//

import UIKit

import SnapKit
import Then

class EmptyMusicCollectionViewCell: BaseCollectionViewCell {
    private let noticeLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 24, weight: .light)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        noticeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(200.adjustedHeight)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()

        addSubview(noticeLabel)
    }
    
    func configure(refresh: EmptyType) {
        noticeLabel.text = refresh.self == .refresh ? "음악을 검색해주세요" : "음악을 다시 검색해주세요"
    }
}

