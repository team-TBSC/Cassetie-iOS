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
    
//    let backgroundStarImageView = UIImageView().then {
//        $0.image = Image.backgroundStarImg
//    }
    
    let cassetieGifImageView = GIFImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let loadingLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 32, weight: .light)
        $0.text = "음원에서 에너지 추출 중!"
    }
    
    let completedStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = -10
        $0.alignment = .center
    }
    
    let completedGifImageView = GIFImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let completedLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 32, weight: .light)
        $0.text = "카세티 생성 완료!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.setCompletedConfigure()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        backgroundStarImageView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(76.adjustedHeight)
//            $0.width.equalTo(669.adjustedWidth)
//            $0.centerX.equalToSuperview()
//            $0.height.equalTo(174.adjustedHeight)
//        }
        
        cassetieGifImageView.snp.makeConstraints {
            $0.width.height.equalTo(650.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(218.adjustedHeight)
        }
        
        completedGifImageView.snp.makeConstraints {
            $0.width.height.equalTo(510.adjustedWidth)
        }
        
        completedStackView.snp.makeConstraints {
            $0.width.equalTo(510.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(500)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cassetieGifImageView.snp.bottom).inset(80)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        completedStackView.addArrangedSubviews([completedGifImageView, completedLabel])
        view.addSubviews([backgroundView, cassetieGifImageView, loadingLabel, completedStackView])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        cassetieGifImageView.animate(withGIFNamed: "cassetie-loading")
        completedGifImageView.animate(withGIFNamed: "cassetie-loading-final")
        
        completedStackView.alpha = 0
    }
    
    func setCompletedConfigure() {
        UIView.animate(withDuration: 1.0, animations: {
            self.loadingLabel.alpha = 0
            self.cassetieGifImageView.alpha = 0
        })
        
        completedStackView.snp.remakeConstraints {
            $0.width.equalTo(510.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(300.adjustedHeight)
        }
        
        UIView.animate(withDuration: 3.0, animations: {
            self.view.layoutIfNeeded()
            self.completedStackView.alpha = 1
        })
    }
}
