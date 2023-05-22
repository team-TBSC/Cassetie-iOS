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
import ReactorKit

class LoadingViewController: BaseViewController, View {
    typealias Reactor = LoadingReactor
    
    var completedCassetie: ConfirmMusicResponseDTO?
    var navigation: UINavigationController?
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
    
    let completeButton = RoundButton(title: "카세티 보러가기", titleColor: .black, backColor: .white, round: 40).then {
        $0.configureFont(font: .systemFont(ofSize: 24, weight: .light))
    }
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(completedStackView.snp.bottom).offset(30)
            $0.width.equalTo(275)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
        }
    }
    
//    override func setupBind() {
//        super.setupBind()
//
//        completeButton.rx.tap
//            .bind { [weak self] in
//                let completeCassetieViewController = CompletedCassetieViewController()
//                completeCassetieViewController.completedCassetie = self?.completedCassetie
//                self?.navigationController?.pushViewController(completeCassetieViewController, animated: true)
//            }
//            .disposed(by: disposeBag)
//    }

    func bind(reactor: LoadingReactor) {
        completeButton.rx.tap
            .bind { [weak self] in
                let completeCassetieViewController = CompletedCassetieViewController()
                completeCassetieViewController.completedCassetie = self?.completedCassetie
                self?.navigationController?.pushViewController(completeCassetieViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isUpdated)
            .filter { $0 }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] _ in
                self?.completedCassetie = reactor.completeCassetie
                self?.completeButton.isEnabled = true
            })
            .disposed(by: disposeBag)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        completedStackView.addArrangedSubviews([completedGifImageView, completedLabel])
        view.addSubviews([backgroundView, backgroundStarImg, cassetieGifImageView, loadingLabel, completedStackView, completeButton])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        cassetieGifImageView.animate(withGIFNamed: "cassetie-loading")
        completedGifImageView.animate(withGIFNamed: "cassetie-loading-final")
        
        completedStackView.alpha = 0
        completeButton.alpha = 0
        
        completeButton.isEnabled = false
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
        
        UIView.animate(withDuration: 2, animations: {
            self.view.layoutIfNeeded()
            self.completedStackView.alpha = 1
        })
        
        UIView.animate(withDuration: 3.5, animations: {
            self.completeButton.alpha = 1
        })
    }
}
