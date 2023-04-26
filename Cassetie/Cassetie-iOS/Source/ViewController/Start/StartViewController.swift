//
//  StartViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/26.
//

import UIKit

import SnapKit
import Then
import RxSwift

class StartViewController: BaseViewController {
    let backgroundView = UIImageView().then {
        $0.image = Image.backgroundImg
    }
    
    let backgroundStarImg = UIImageView().then {
        $0.image = Image.backgroundStarImg
    }
    
    let logoImg = UIImageView().then {
        $0.image = Image.teamLogoImg
    }
    
    let startButton = UIButton().then {
        $0.setTitle("카세티 보러 떠나기", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel!.font = .systemFont(ofSize: 24, weight: .thin)
        $0.setUnderline()
    }
    
    let goToFinalButton = UIButton().then {
        $0.setTitle("다른 카세티 확인하기", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel!.font = .systemFont(ofSize: 24, weight: .thin)
        $0.setUnderline()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonAnimation()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundStarImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImg.snp.makeConstraints {
            $0.width.equalTo(412.adjustedWidth)
            $0.height.equalTo(380.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(370.adjustedHeight)
        }
        
        startButton.snp.makeConstraints {
            $0.width.equalTo(188)
            $0.height.equalTo(50)
            $0.top.equalTo(logoImg.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        goToFinalButton.snp.makeConstraints {
            $0.width.equalTo(208)
            $0.height.equalTo(50)
            $0.top.equalTo(startButton.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        startButton.rx.tap
            .bind { [weak self] in
                let firstStoryTutorialViewController = FirstStoryTutorialViewController()
                self?.navigationController?.pushViewController(firstStoryTutorialViewController, animated: false)
            }
            .disposed(by: disposeBag)
        
        goToFinalButton.rx.tap
            .bind { [weak self] in
                let finalViewController = RootSwitcher.final.page
                self?.navigationController?.pushViewController(finalViewController, animated: false)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, backgroundStarImg, logoImg, startButton, goToFinalButton])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        self.startButton.alpha = 0
        self.goToFinalButton.alpha = 0
    }
    
    func setButtonAnimation() {
        UIView.animate(withDuration: 4, animations: {
            self.startButton.alpha = 1
            self.goToFinalButton.alpha = 1
        })
    }
}
