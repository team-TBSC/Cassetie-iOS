//
//  FinalViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/21.
//

import UIKit

import Then
import SnapKit
import ReactorKit
import RxSwift
import RxDataSources
import RxViewController

enum Carousel {
    static let itemSize = CGSize(width: 516.adjustedWidth, height: 780.adjustedHeight)
    
    static var inset: CGFloat {
        (UIScreen.main.bounds.width - Carousel.itemSize.width) / 2.0
    }
}

class FinalViewController: BaseViewController, View, UIScrollViewDelegate {
    
    typealias Reactor = FinalReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<FinalSectionModel>
    
    let dataSource = DataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .cassetieBox(model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CassetieBoxCollectionViewCell.self), for: indexPath) as? CassetieBoxCollectionViewCell else { return .init() }
            cell.configure(model)
            return cell
        }
    }
    
    let backgroundImage = UIImageView().then {
        $0.image = Image.backgroundImg
    }
    
    let backgroundStarImg = UIImageView().then {
        $0.image = Image.backgroundStarImg
    }
    
    let noticeTopLabel = UILabel().then {
        $0.attributedText = NSMutableAttributedString()
            .light(string: "여러분의 ", fontSize: 36)
            .bold(string: "카세티", fontSize: 36)
            .light(string: "를", fontSize: 36)
        $0.textColor = .white
    }
    
    let noticeBottomLabel = UILabel().then {
        $0.text = "확인해보세요"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 36, weight: .light)
    }
    
    let noticeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 7
    }
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 20
        $0.sectionInset = UIEdgeInsets(top: 0, left: Carousel.inset, bottom: 0, right: Carousel.inset)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
    }
    
    let refreshButton = UIButton().then {
        $0.setImage(Image.icRefresh, for: .normal)
    }
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundStarImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noticeStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(90.adjustedHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(780.adjustedHeight)
            $0.centerY.equalToSuperview().offset(20)
        }
        
        refreshButton.snp.makeConstraints {
            $0.width.height.equalTo(37)
            $0.trailing.bottom.equalToSuperview().inset(40)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        noticeStackView.addArrangedSubviews([noticeTopLabel, noticeBottomLabel])
        view.addSubviews([backgroundImage,backgroundStarImg, noticeStackView, collectionView, refreshButton])
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        collectionView.register(CassetieBoxCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CassetieBoxCollectionViewCell.self))
    }
    
    func bind(reactor: FinalReactor) {
        refreshButton.rx.tap
            .bind(onNext: {
                reactor.action.onNext(.refresh)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(FinalItem.self)
            .subscribe(onNext: { item in
                guard case let .cassetieBox(item) = item else { return }
                
                let songList: [Song] = item.song.map { sing in
                    Song(track: sing.track, artist: sing.artist, image: sing.image)
                }
                
                let userCustomViewController = UserCustomViewController()
                userCustomViewController.songDTO = songList
                userCustomViewController.userName = item.name
                userCustomViewController.modalPresentationStyle = .overCurrentContext
                self.present(userCustomViewController, animated: false)
                
            })
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.finalSection)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension FinalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 516.adjustedWidth
        let height = 780.adjustedHeight
        
        return CGSize(width: width, height: height)
    }
}
