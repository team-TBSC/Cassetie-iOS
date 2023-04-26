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
import RxSwift
import RxGesture

class LoadingViewController: BaseViewController {
    var completedCassetie: ConfirmMusicResponseDTO?
    
    let backgroundView = UIImageView().then {
        $0.image = Image.backgroundImg
    }
    
    let backgroundStarImg = UIImageView().then {
        $0.image = Image.backgroundStarImg
    }
    
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
    
    let icConfirmImage = UIImageView().then {
        $0.image = Image.icConfirm
    }
    
    let goToCompledtedCasstieLabel = UILabel().then {
        $0.text = "카세티 보러가기"
        $0.font = .systemFont(ofSize: 24, weight: .light)
        $0.textColor = .black
    }
    
    let goToCompletedCassetieView = UIView()
    
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
        
        backgroundStarImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cassetieGifImageView.snp.makeConstraints {
            $0.width.height.equalTo(650.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(218.adjustedHeight)
        }
        
        completedGifImageView.snp.makeConstraints {
            $0.width.height.equalTo(460.adjustedWidth)
        }
        
        completedStackView.snp.makeConstraints {
            $0.width.equalTo(510.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(150)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cassetieGifImageView.snp.bottom).inset(90)
        }
        
        icConfirmImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        goToCompletedCassetieView.snp.makeConstraints {
            $0.top.equalTo(loadingLabel.snp.bottom).offset(35)
            $0.width.equalTo(275)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
        }
        
        goToCompledtedCasstieLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        goToCompletedCassetieView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: {_ in
                let completedCassetieViewController = CompletedCassetieViewController()
                if let cassetie = self.completedCassetie {
                    completedCassetieViewController.completedCassetie = cassetie
                }
                self.navigationController?.pushViewController(completedCassetieViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        completedStackView.addArrangedSubviews([completedGifImageView, completedLabel])
        goToCompletedCassetieView.addSubviews([icConfirmImage, goToCompledtedCasstieLabel])
        view.addSubviews([backgroundView, backgroundStarImg, cassetieGifImageView, loadingLabel, completedStackView, goToCompletedCassetieView])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        cassetieGifImageView.animate(withGIFNamed: "cassetie-loading")
        completedGifImageView.animate(withGIFNamed: "cassetie-loading-final")
        
        completedStackView.alpha = 0
        goToCompletedCassetieView.alpha = 0
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
        
        UIView.animate(withDuration: 2.5, animations: {
            self.view.layoutIfNeeded()
            self.completedStackView.alpha = 1
        })
        
        UIView.animate(withDuration: 4, animations: {
            self.goToCompletedCassetieView.alpha = 1
        })
    }
}
