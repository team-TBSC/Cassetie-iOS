//
//  LoadingViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/15.
//

import UIKit

import SnapKit
import Then
import Gifu

class LoadingViewController: BaseViewController {
    let backgroundView = UIImageView().then {
        $0.image = Image.backgroundImg
    }
    
    let backgroundStarImageView = UIImageView().then {
        $0.image = Image.backgroundStarImg
    }
    
    let cassetieGifImageView = GIFImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    var loadingLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 32, weight: .light)
        $0.text = "음원에서 에너지 추출 중!"
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundStarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76.adjustedHeight)
            $0.width.equalTo(669.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(174.adjustedHeight)
        }
        
        cassetieGifImageView.snp.makeConstraints {
            $0.width.height.equalTo(650.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(218.adjustedHeight)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cassetieGifImageView.snp.bottom).inset(60)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, backgroundStarImageView, cassetieGifImageView, loadingLabel])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        cassetieGifImageView.animate(withGIFNamed: "cassetie-loading")
    }
}
