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
import AVFoundation

class BottomSheetViewController: BaseViewController, View {
    typealias Reactor = BottomSheetReactor
    
    var musicList: MusicListDTO = .init()
    var selectedIndex = Int()
    private let player = AVPlayer()
    private var url: URL? {
      didSet {
        guard let url = self.url else { return self.player.replaceCurrentItem(with: nil) }
        let item = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: item)
      }
    }
    
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
        $0.cornerRound(radius: 5)
    }
    
    private let selectedLabel = UILabel().then {
        $0.text = "선택완료"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 24, weight: .light)
    }
    
    private let icSelectedImg = UIImageView().then {
        $0.image = Image.icSelected
    }
    
    private let selectedAlbumCoverView = UIView().then {
        $0.cornerRound(radius: 5)
        $0.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    private let confirmButton = RoundButton(title: "확정하기", titleColor: .black, backColor: .white, round: 40).then {
        $0.configureFont(font: .systemFont(ofSize: 24, weight: .light))
    }
    
    private let goBackButton = RoundButton(title: "돌아가기", titleColor: .black, backColor: .white, round: 40).then {
        $0.configureFont(font: .systemFont(ofSize: 24, weight: .light))
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
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
        
        if let musicURL = musicList.previewURL {
            self.url = URL(string: musicURL)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.player.play()
        }
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
        selectedAlbumCoverView.alpha = 0
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
        
        selectedAlbumCoverView.snp.makeConstraints {
            $0.width.height.equalTo(238.adjustedWidth)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(musicDetailStackView.snp.bottom).offset(60.adjustedHeight)
        }
        
        icSelectedImg.snp.makeConstraints {
            $0.width.height.equalTo(68)
            $0.top.equalTo(selectedAlbumCoverView).offset(69)
            $0.centerX.equalToSuperview()
        }
        
        selectedLabel.snp.makeConstraints {
            $0.top.equalTo(icSelectedImg.snp.bottom).offset(9)
            $0.centerX.equalToSuperview()
        }
    
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(243)
            $0.height.equalTo(76)
        }
        
        goBackButton.snp.makeConstraints {
            $0.width.equalTo(243)
            $0.height.equalTo(76)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.width.equalTo(520)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(albumCoverImage.snp.bottom).offset(110.adjustedHeight)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        musicDetailStackView.addArrangedSubviews([titleLable, singerLable])
        selectedAlbumCoverView.addSubviews([icSelectedImg, selectedLabel])
        buttonStackView.addArrangedSubviews([confirmButton, goBackButton])
        bottomSheetView.contentView.addSubviews([bottomSheetIcon, musicDetailStackView, albumCoverImage, buttonStackView, selectedAlbumCoverView])
        
        view.addSubviews([backgroundView, bottomSheetView])
    }
    
    // MARK: - bind
    func bind(reactor: BottomSheetReactor) {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { this, gesture in
                self.stopMusic()
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
                        self.stopMusic()
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
        
        goBackButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                self.stopMusic()
                self.disappearBottomSheet()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { this, _ in
                self.selectedAlbumCoverView.alpha = 1
                reactor.action.onNext(.select(self.musicList, self.selectedIndex))
                
                NetworkService.shared.search.event.onNext(.closeBottomSheet)
                
                self.stopMusic()
                self.disappearBottomSheet()

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
      
//        albumCoverImage.rx.tapGesture()
//            .when(.recognized)
//            .withUnretained(self)
//            .bind { this, _ in
//                self.selectedAlbumCoverView.alpha = 1
//                reactor.action.onNext(.select(self.musicList, self.selectedIndex))
//            }
//            .disposed(by: disposeBag)
        
    }
    
    // MARK: - 바텀시트 열릴 때
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
    
    // MARK: - 바텀시트 닫힐 때
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
    
    func stopMusic() {
        self.player.pause()
        self.player.seek(to: .zero)
    }
    
    func configure(singer: String, title: String, image: String) {
        let url = URL(string: image)
        self.albumCoverImage.kf.setImage(with: url)
        self.titleLable.text = title
        self.singerLable.text = singer
    }
}
