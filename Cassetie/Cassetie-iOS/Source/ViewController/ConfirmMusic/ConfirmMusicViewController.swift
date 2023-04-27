//
//  ConfirmMusicViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/10.
//

import UIKit

import SnapKit
import Then
import ReactorKit
import RxDataSources
import RxViewController

class ConfirmMusicViewController: BaseViewController, View {
    private let blurEffect = UIBlurEffect(style: .dark)
    private lazy var backgroundEffectView = UIVisualEffectView(effect: self.blurEffect)
    
    typealias Reactor = ConfirmMusicReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SearchSectionModel>

    let dataSource = DataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .musicPreview(model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self), for: indexPath) as? MusicPreviewCollectionViewCell else { return .init() }
            cell.configure(model)
            return cell
        case .emptyMusicPreview:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmptyMusicCollectionViewCell.self), for: indexPath) as? EmptyMusicCollectionViewCell else { return .init() }
            return cell
        }
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = Color.navyD.withAlphaComponent(0.9)
        $0.cornerRound(radius: 24)
    }
    private let noticeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .center
    }
    private let noticeTopLable = UILabel().then {
        $0.text = "선택하신 음악이에요."
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .white
    }
    private let noticeBottomLable = UILabel().then {
        $0.text = "이 음악들을 카세티한테 전할까요?"
        $0.font = .systemFont(ofSize: 24, weight: .light)
        $0.textColor = .white
    }
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
    }
    private let bottomButton = RoundButton(
        title: "좀 더 고민해보기",
        titleColor: .white,
        backColor: Color.navyL,
        round: 40
    )
    private let topButton = RoundButton(
        title: "카세티 보러가기!",
        titleColor: .black,
        backColor: .white,
        round: 40
    )
    var navigation: UINavigationController?
    
    init(reactor: Reactor, navigationController: UINavigationController?) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.navigation = navigationController
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints {
            $0.width.equalTo(603)
            $0.height.equalTo(1004)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        noticeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(43)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalTo(503)
            $0.height.equalTo(569)
            $0.top.equalTo(noticeStackView.snp.bottom).offset(48)
            $0.centerX.equalTo(backgroundView)
        }
        
        bottomButton.snp.makeConstraints {
            $0.width.equalTo(370)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(53)
        }
        
        topButton.snp.makeConstraints {
            $0.width.equalTo(370)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top).inset(-20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        noticeStackView.addArrangedSubviews([noticeTopLable, noticeBottomLable])
        backgroundView.addSubviews([noticeStackView, collectionView, topButton, bottomButton])
        view.addSubviews([backgroundEffectView, backgroundView])
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        collectionView.register(MusicPreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self))
        collectionView.register(EmptyMusicCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyMusicCollectionViewCell.self))
    }
    
    func bind(reactor: ConfirmMusicReactor) {
        bottomButton.rx.tap
            .bind { _ in
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        topButton.rx.tap
            .bind { _ in
                reactor.action.onNext(.post)
                
                self.dismiss(animated: false)
                let loadingViewController = RootSwitcher.loading.page
                self.navigation?.pushViewController(loadingViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.musicPreviewSection)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension ConfirmMusicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width
        let height = self.collectionView.frame.height / 5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
