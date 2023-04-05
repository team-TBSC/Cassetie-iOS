//
//  BottomSheetViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/06.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxGesture
import Kingfisher
import ReactorKit

class BottomSheetViewController: BaseViewController, View {
    typealias Reactor = BottomSheetReactor
    
    var musicList: MusicListDTO = .init()
    var index = Int()
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let blurEffect = UIBlurEffect(style: .dark)
    private lazy var bottomSheetView = UIVisualEffectView(effect: self.blurEffect).then {
        $0.cornerRound(radius: 40, direct: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
    }
    
    private let bottomSheetHeight: CGFloat = 720.adjustedHeight
    
    private let bottomSheetIcon = UIImageView().then {
        $0.image = Image.icBottomSheet
    }
    
    private let musicDetailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
    }
    
    private let titleLable = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .white
    }
    
    private let singerLable = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .regular)
        $0.textColor = .white
    }
    
    private let albumCoverImage = UIImageView().then {
        $0.cornerRound(radius: 3)
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 30.adjustedWidth
    }
    
    private let leftButton = RoundButton(title: "돌아가기", titleColor: .black, backColor: .white, round: 40).then {
        $0.configureFont(font: .systemFont(ofSize: 24, weight: .light))
    }
    
    private let rightButton = RoundButton(title: "노래 선택하기", titleColor: .black, backColor: .white, round: 40).then {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disappearBottomSheet()
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        self.view.backgroundColor = .clear
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.adjustedHeight)
        }
        
        bottomSheetIcon.snp.makeConstraints {
            $0.width.equalTo(61.adjustedWidth)
            $0.height.equalTo(4.adjustedHeight)
            $0.top.equalTo(bottomSheetView.snp.top).offset(25)
            $0.centerX.equalTo(bottomSheetView)
        }
        
        musicDetailStackView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetIcon.snp.bottom).offset(50.adjustedHeight)
            $0.centerX.equalToSuperview()
        }
        
        albumCoverImage.snp.makeConstraints {
            $0.width.height.equalTo(238.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(musicDetailStackView.snp.bottom).offset(60.adjustedHeight)
        }
        
        [leftButton, rightButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(243)
                $0.height.equalTo(76)
            }
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(albumCoverImage.snp.bottom).offset(110.adjustedHeight)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        musicDetailStackView.addArrangedSubviews([titleLable, singerLable])
        buttonStackView.addArrangedSubviews([leftButton, rightButton])
        bottomSheetView.contentView.addSubviews([bottomSheetIcon, musicDetailStackView, albumCoverImage, buttonStackView])
        
        view.addSubviews([backgroundView, bottomSheetView])
    }
    
    func bind(reactor: BottomSheetReactor) {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { this, gesture in
                self.disappearBottomSheet()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    this.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        bottomSheetView.rx.panGesture()
            .withUnretained(self)
            .bind { this, gesture in
                let translation = gesture.translation(in: self.backgroundView)
                
                guard translation.y > 0 else { return }
                
                switch gesture.state {
                case .ended:
                    if translation.y > self.bottomSheetHeight / 2 {
                        this.dismiss(animated: true)
                    } else {
                        self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: 0)
                    }
                case .changed:
                    self.bottomSheetView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        leftButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                self.disappearBottomSheet()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .map { _ in Reactor.Action.select(self.musicList, self.index) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isSelected)
            .filter { $0 }
            .bind { _ in
                self.disappearBottomSheet()

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)

    }
    
    private func showBottomSheet() {
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(720.adjustedHeight)
        }
        
        UIView.animate(
            withDuration: 0.5,
            animations: self.view.layoutIfNeeded
        )
    }
    
    private func disappearBottomSheet() {
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.adjustedHeight)
        }
        
        UIView.animate(
            withDuration: 0.5,
            animations: self.view.layoutIfNeeded
        )
    }
    
    func configure(singer: String, title: String, image: String) {
        let url = URL(string: image)
        self.albumCoverImage.kf.setImage(with: url)
        self.titleLable.text = title
        self.singerLable.text = singer
    }
}
