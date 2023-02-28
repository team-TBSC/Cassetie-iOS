//
//  SearchViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/02/22.
//

import UIKit

import Then
import RxSwift
import ReactorKit
import SnapKit
import RxDataSources
import RxViewController

class SearchViewController: BaseViewController, View {
    
    typealias Reactor = SearchReactor
    typealias SearchDataSource = RxCollectionViewSectionedReloadDataSource<SearchSectionModel>
    
    let dataSource = SearchDataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .musicPreview(model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self), for: indexPath) as? MusicPreviewCollectionViewCell else { return .init() }
            cell.configure(model)
            return cell
        }
    }
    
    let backgroundView = UIImageView().then {
        $0.image = Image.backgroundImg
    }
    
    let searchBackgroundView = UIView().then {
        $0.backgroundColor = Color.grayL
        $0.alpha = 0.4
        $0.cornerRound(radius: 24, direct: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
    }
    
    let searchBarBackgrundView = UIView().then {
        $0.backgroundColor = Color.grayD
        $0.alpha = 0.2
        $0.cornerRound(radius: 23)
    }
    
    let searchIcon = UIImageView().then {
        $0.image = Image.icSearch
    }
    
    let textField = UITextField().then {
        $0.borderStyle = .none
        $0.clearButtonMode = .always
        $0.textColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "노래 제목을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
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
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(694)
        }
        
        searchBarBackgrundView.snp.makeConstraints {
            $0.top.equalTo(searchBackgroundView).inset(28)
            $0.leading.trailing.equalTo(searchBackgroundView).inset(47)
            $0.height.equalTo(46)
        }
        
        searchIcon.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.leading.equalTo(searchBarBackgrundView).inset(18)
            $0.centerY.equalTo(searchBarBackgrundView)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalTo(searchIcon).offset(40)
            $0.top.bottom.equalTo(searchBarBackgrundView)
            $0.trailing.equalTo(searchBarBackgrundView).inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarBackgrundView.snp.bottom).offset(33)
            $0.leading.trailing.equalTo(searchBackgroundView).inset(47)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, searchBackgroundView, searchBarBackgrundView, searchIcon, textField, collectionView])
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        collectionView.register(MusicPreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self))
    }

    func bind(reactor: SearchReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.musicPreviewSection)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath.section].model {
        case .musicPreview:
            let width = self.collectionView.frame.width
            let height = 113.0
            
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch dataSource[section].model {
        case .musicPreview:
            return 0
        }
    }
}
