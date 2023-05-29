//
//  UserCustomMusicListViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/05/22.
//

import UIKit

import SnapKit
import Then
import ReactorKit
import RxDataSources
import RxViewController

class UserCustomViewController: BaseViewController {
    private let blurEffect = UIBlurEffect(style: .dark)
    private lazy var backgroundEffectView = UIVisualEffectView(effect: self.blurEffect)

    private let backgroundView = UIView().then {
        $0.backgroundColor = Color.navyD.withAlphaComponent(0.9)
        $0.cornerRound(radius: 24)
    }
    private let mentionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    private let firstTextLabel = UILabel().then {
        $0.text = "텐션"
    }
    private let secondTextLabel = UILabel().then {
        $0.text = "감정"
    }
    private let thirdTextLabel = UILabel().then {
        $0.text = "외형"
    }
    private let fourthTextLabel = UILabel().then {
        $0.text = "커스텀"
    }
    private let fivthTextLabel = UILabel().then {
        $0.text = "대표 노래"
    }
    private let customTextStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    private let totalStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let mentionTopLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .white
    }
    private let mentionBottomLabel = UILabel().then {
        $0.text = "음악 목록"
        $0.font = .systemFont(ofSize: 28, weight: .medium)
        $0.textColor = .white
    }
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
    }
    private let backButton = RoundButton(
        title: "돌아가기",
        titleColor: .white,
        backColor: Color.navyL,
        round: 40
    )
    var songDTO: [Song]?
    var userName: String?
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(633)
            $0.height.equalTo(904)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        mentionStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(43)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalTo(453)
            $0.height.equalTo(540)
        }
        
        customTextStackView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(540)
        }
        
        totalStackView.snp.makeConstraints {
            $0.width.equalTo(533)
            $0.height.equalTo(540)
            $0.top.equalTo(mentionStackView.snp.bottom).offset(48)
            $0.centerX.equalTo(backgroundView)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(370)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(53)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        mentionStackView.addArrangedSubviews([mentionTopLabel, mentionBottomLabel])
        [firstTextLabel, secondTextLabel, thirdTextLabel, fourthTextLabel, fivthTextLabel].forEach {
            customTextStackView.addArrangedSubview($0)
        }
        totalStackView.addArrangedSubviews([collectionView, customTextStackView])
        backgroundView.addSubviews([mentionStackView, totalStackView, backButton])
        view.addSubviews([backgroundEffectView, backgroundView])
    }
    
    override func setupProperty() {
        super.setupProperty()

        mentionTopLabel.attributedText = NSMutableAttributedString()
            .bold(string: self.userName ?? "", fontSize: 36)
            .regular(string: "의", fontSize: 36)
        
        [firstTextLabel, secondTextLabel, thirdTextLabel, fourthTextLabel, fivthTextLabel].forEach {
            $0.font = .systemFont(ofSize: 20, weight: .light)
            $0.textColor = .white.withAlphaComponent(0.5)
        }
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MusicPreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self))
    }
    
    override func setupBind() {
        super.setupBind()
        
        backButton.rx.tap
            .bind(onNext: {
                self.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
}

extension UserCustomViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: "MusicPreviewCollectionViewCell",
            for: indexPath) as? MusicPreviewCollectionViewCell else { return UICollectionViewCell() }
        
        guard let songDTO = self.songDTO else { return UICollectionViewCell() }
        cell.simpleConfigure(songDTO[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width
        let height = self.collectionView.frame.height / 5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
