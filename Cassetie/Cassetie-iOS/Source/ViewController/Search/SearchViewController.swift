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
    typealias AskQuestionDataSource = RxCollectionViewSectionedReloadDataSource<AskQuestionSectionModel>
    
    let searchDataSource = SearchDataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .musicPreview(model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self), for: indexPath) as? MusicPreviewCollectionViewCell else { return .init() }
            cell.configure(model)
            return cell
        }
    }
    
    let askQuestionDataSource = AskQuestionDataSource { _, collectionView, indexPath, item ->
        UICollectionViewCell in
        switch item {
        case let .askQuestion(type):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AskQuestionCollectionViewCell.self), for: indexPath) as? AskQuestionCollectionViewCell else { return .init() }
            cell.configure(type)
            return cell
        }
    }
    
    let backgroundView = UIImageView().then {
        $0.image = Image.backgroundImg
    }
    
    let leftButton = UIButton().then {
        $0.setImage(Image.icLeft, for: .normal)
    }
    
    let rightButton = UIButton().then {
        $0.setImage(Image.icRight, for: .normal)
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
        $0.scrollDirection = .vertical
    }
    
    let askQuestionCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
    }
    
    lazy var askQuestionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: askQuestionCollectionViewFlowLayout).then {
        $0.backgroundColor = .clear
    }
    
    let pageControl = UIPageControl().then {
        $0.numberOfPages = 5
        $0.pageIndicatorTintColor = Color.grayDL.withAlphaComponent(0.2)
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
        
        leftButton.snp.makeConstraints {
            $0.width.height.equalTo(59)
            $0.leading.equalToSuperview().offset(113)
            $0.top.equalToSuperview().offset(204)
        }
        
        rightButton.snp.makeConstraints {
            $0.width.height.equalTo(59)
            $0.trailing.equalToSuperview().inset(113)
            $0.top.equalToSuperview().offset(204)
        }
        
        askQuestionCollectionView.snp.makeConstraints {
            $0.leading.equalTo(leftButton.snp.trailing)
            $0.trailing.equalTo(rightButton.snp.leading)
            $0.height.equalTo(330)
            $0.top.equalToSuperview().offset(50)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(askQuestionCollectionView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(13)
//            $0.width.equalTo(88)
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
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarBackgrundView.snp.bottom).offset(33)
            $0.leading.equalTo(searchBackgroundView.snp.leading).offset(47)
            $0.trailing.equalTo(searchBackgroundView.snp.trailing).inset(47)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, leftButton, rightButton, askQuestionCollectionView, pageControl, searchBackgroundView, searchBarBackgrundView, searchIcon, textField, searchCollectionView])
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        searchCollectionView.register(MusicPreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self))
        askQuestionCollectionView.register(AskQuestionCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: AskQuestionCollectionViewCell.self))
    }

    func bind(reactor: SearchReactor) {
        rightButton.rx.tap
            .bind { [weak self] _ in
                guard let currentIndexPath = self?.askQuestionCollectionView.indexPathsForVisibleItems.first else {
                    return
                }
                let nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
                
                if nextIndexPath.item < self!.askQuestionCollectionView.numberOfItems(inSection: nextIndexPath.section) {
                    DispatchQueue.main.async { [weak self] in
                        self?.askQuestionCollectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                    }
                    
                    self?.pageControl.currentPage = nextIndexPath.item
                }
            }
            .disposed(by: disposeBag)
        
        leftButton.rx.tap
            .bind { [weak self] _ in
                guard let currentIndexPath = self?.askQuestionCollectionView.indexPathsForVisibleItems.first else {
                    return
                }
                let nextIndexPath = IndexPath(item: currentIndexPath.item - 1, section: currentIndexPath.section)
                
                if nextIndexPath.item >= 0 {
                    DispatchQueue.main.async { [weak self] in
                        self?.askQuestionCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
                    }
                    
                    self?.pageControl.currentPage = nextIndexPath.item
                }
            }
            .disposed(by: disposeBag)
    
        rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.musicPreviewSection)
            .bind(to: searchCollectionView.rx.items(dataSource: searchDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.askQuestionSection)
            .bind(to: askQuestionCollectionView.rx.items(dataSource: askQuestionDataSource))
            .disposed(by: disposeBag)

        searchCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        askQuestionCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchCollectionView {
            let width = self.searchCollectionView.frame.width
            let height = 113.0

            return CGSize(width: width, height: height)
        } else {
            let width = self.askQuestionCollectionView.frame.width
            let height = 330.0
            
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
