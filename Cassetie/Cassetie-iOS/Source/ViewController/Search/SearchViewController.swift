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
import Gifu

class SearchViewController: BaseViewController, View, UITextFieldDelegate {
    typealias Reactor = SearchReactor
    typealias SearchDataSource = RxCollectionViewSectionedReloadDataSource<SearchSectionModel>
    typealias AskQuestionDataSource = RxCollectionViewSectionedReloadDataSource<AskQuestionSectionModel>
    
    let searchDataSource = SearchDataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .musicPreview(model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self), for: indexPath) as? MusicPreviewCollectionViewCell else { return .init() }
            cell.configure(model)
            return cell
        case let .emptyMusicPreview(type):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmptyMusicCollectionViewCell.self), for: indexPath) as? EmptyMusicCollectionViewCell else { return .init() }
            cell.configure(refresh: type)
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
    
    let backgroundStarImg = UIImageView().then {
        $0.image = Image.backgroundStarImg
    }
    
    let leftButton = UIButton().then {
        $0.setImage(Image.icLeft, for: .normal)
        $0.isHidden = true
    }
    
    let rightButton = UIButton().then {
        $0.setImage(Image.icRight, for: .normal)
        $0.isEnabled = false
    }
    
    let finalTextImage = UIImageView().then {
        $0.image = Image.finalTextImage
        $0.isHidden = true
    }
    
    let searchBackgroundView = UIImageView().then {
        $0.image = Image.backgroundSearchImg
    }
    
    let searchBarBackgroundView = UIView().then {
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
        $0.isScrollEnabled = false
    }
    
    lazy var progressBar = UIProgressView().then {
        $0.trackTintColor = .white.withAlphaComponent(0.5)
        $0.progressTintColor = .white
        $0.cornerRound(radius: 5)
    }
    
    let percentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .light)
        $0.textColor = .white
    }
    
    let progressStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
    }
    
    var currentCell: Int = 0 {
        didSet {
            if currentCell == askQuestionCollectionView.numberOfItems(inSection: 0) - 1 {
                rightButton.setImage(Image.icRightFinal, for: .normal)
                finalTextImage.isHidden = false
            } else if currentCell == 0 {
                leftButton.isHidden = true
            } else {
                leftButton.isHidden = false
                finalTextImage.isHidden = true
                rightButton.setImage(Image.icRight, for: .normal)
            }
        }
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
        
        backgroundStarImg.snp.makeConstraints {
            $0.width.equalTo(self.view.frame.width)
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(-50)
            $0.bottom.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.width.height.equalTo(75.adjustedWidth)
            $0.leading.equalToSuperview().offset(105.adjustedWidth)
            $0.top.equalToSuperview().offset(185.adjustedHeight)
        }
        
        rightButton.snp.makeConstraints {
            $0.width.height.equalTo(75.adjustedWidth)
            $0.trailing.equalToSuperview().inset(105.adjustedWidth)
            $0.top.equalToSuperview().offset(185.adjustedHeight)
        }
        
        finalTextImage.snp.makeConstraints {
            $0.top.equalTo(rightButton.snp.bottom).offset(-18)
            $0.leading.equalTo(rightButton.snp.leading).offset(-7)
            $0.height.equalTo(58.adjustedHeight)
            $0.width.equalTo(94.adjustedWidth)
        }
        
        askQuestionCollectionView.snp.makeConstraints {
            $0.leading.equalTo(leftButton.snp.trailing)
            $0.trailing.equalTo(rightButton.snp.leading)
            $0.height.equalTo(360.adjustedHeight)
            $0.top.equalToSuperview().offset(45.adjustedHeight)
        }
        
        progressBar.snp.makeConstraints {
            $0.width.equalTo(230)
            $0.height.equalTo(8)
        }
        
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(askQuestionCollectionView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        searchBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(694.adjustedHeight)
        }
        
        searchBarBackgroundView.snp.makeConstraints {
            $0.top.equalTo(searchBackgroundView).inset(28)
            $0.leading.trailing.equalTo(searchBackgroundView).inset(47)
            $0.height.equalTo(46.adjustedHeight)
        }
        
        searchIcon.snp.makeConstraints {
            $0.height.width.equalTo(24.adjustedWidth)
            $0.leading.equalTo(searchBarBackgroundView).inset(18)
            $0.centerY.equalTo(searchBarBackgroundView)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalTo(searchIcon).offset(40)
            $0.top.bottom.equalTo(searchBarBackgroundView)
            $0.trailing.equalTo(searchBarBackgroundView).inset(20)
        }
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarBackgroundView.snp.bottom).offset(33.adjustedHeight)
            $0.leading.equalTo(searchBackgroundView.snp.leading).offset(47)
            $0.trailing.equalTo(searchBackgroundView.snp.trailing).inset(47)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        progressStackView.addArrangedSubviews([progressBar, percentLabel])
        view.addSubviews([backgroundView, backgroundStarImg, leftButton, rightButton, finalTextImage, askQuestionCollectionView, progressStackView, searchBackgroundView, searchBarBackgroundView, searchIcon, textField, searchCollectionView])
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        textField.delegate = self
        searchCollectionView.register(MusicPreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MusicPreviewCollectionViewCell.self))
        searchCollectionView.register(EmptyMusicCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyMusicCollectionViewCell.self))
        askQuestionCollectionView.register(AskQuestionCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: AskQuestionCollectionViewCell.self))
    }
    
    func bind(reactor: SearchReactor) {
        rightButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                guard let currentIndexPath = self.askQuestionCollectionView.indexPathsForVisibleItems.first else {
                    return
                }
                
                let nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
                
                if nextIndexPath.item < self.askQuestionCollectionView.numberOfItems(inSection: nextIndexPath.section) {
                    DispatchQueue.main.async { [weak self] in
                        self?.askQuestionCollectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                    }
                    
                    self.currentCell = nextIndexPath.item
                    
                    if reactor.currentState.selectedMusicList[self.currentCell].isSelected {
                        self.rightButton.isEnabled = true
                    } else {
                        self.rightButton.isEnabled = false
                    }
                } else {
                    let confirmMusicViewController = ConfirmMusicViewController(reactor: .init(), navigationController: self.navigationController)
                    confirmMusicViewController.modalPresentationStyle = .overCurrentContext
                    self.present(confirmMusicViewController, animated: false)
                    
                    reactor.action.onNext(.confirm)
                }
                
                self.textField.text = ""
                reactor.action.onNext(.update(""))
            }
            .disposed(by: disposeBag)
        
        leftButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                guard let currentIndexPath = self.askQuestionCollectionView.indexPathsForVisibleItems.first else {
                    return
                }
                
                let nextIndexPath = IndexPath(item: currentIndexPath.item - 1, section: currentIndexPath.section)
                
                if nextIndexPath.item >= 0 {
                    DispatchQueue.main.async { [weak self] in
                        self?.askQuestionCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
                    }
                    
                    self.currentCell = nextIndexPath.item
                    
                    if reactor.currentState.selectedMusicList[self.currentCell].isSelected {
                        self.rightButton.isEnabled = true
                    } else {
                        self.rightButton.isEnabled = false
                    }
                }
                
                self.textField.text = ""
                reactor.action.onNext(.update(""))
            }
            .disposed(by: disposeBag)
        
        textField.rx.text
            .compactMap { $0 }
            .skip(1)
            .distinctUntilChanged()
//            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .map { text in Reactor.Action.update(text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchCollectionView.rx.modelSelected(SearchItem.self)
            .subscribe(onNext: { item in
                self.textField.resignFirstResponder()
                
                guard case let .musicPreview(music) = item else { return }
                
                let bottomSheetViewController = BottomSheetViewController(reactor: BottomSheetReactor.init())
                bottomSheetViewController.modalPresentationStyle = .overFullScreen
                bottomSheetViewController.configure(singer: music.artist, title: music.track, image: music.image)
                bottomSheetViewController.musicList = music
                bottomSheetViewController.selectedIndex = self.currentCell
                self.present(bottomSheetViewController, animated: false)
            })
            .disposed(by: disposeBag)
    
        rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.bottomSheetState)
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .bind { this, state in
                let nextIndexPath = IndexPath(item: self.currentCell + 1, section: 0)
        
                if nextIndexPath.item < self.askQuestionCollectionView.numberOfItems(inSection: nextIndexPath.section) {
                    DispatchQueue.main.async { [weak self] in
                        self?.askQuestionCollectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                    }
                    
                    self.currentCell = nextIndexPath.item
                    
                    if reactor.currentState.selectedMusicList[self.currentCell].isSelected {
                        self.rightButton.isEnabled = true
                    } else {
                        self.rightButton.isEnabled = false
                    }
                }
                
                self.textField.text = ""
                reactor.action.onNext(.update(""))
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.musicPreviewSection)
            .bind(to: searchCollectionView.rx.items(dataSource: searchDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.askQuestionSection)
            .bind(to: askQuestionCollectionView.rx.items(dataSource: askQuestionDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.selectedMusicList)
            .bind { this in
                if this[self.currentCell].isSelected {
                    self.rightButton.isEnabled = true
                } else {
                    self.rightButton.isEnabled = false
                }
                
            }.disposed(by: disposeBag)
        
        reactor.state
            .map(\.selectedMusicIndex)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] index in
                self?.percentLabel.text = String(index * 20) + "%"
                self?.progressBar.setProgress(Float(Float(index) * 0.2), animated: true)
            })
            .disposed(by: disposeBag)

        searchCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        askQuestionCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchCollectionView {
            switch searchDataSource[indexPath.section].items[indexPath.row] {
            case .musicPreview:
                let width = self.searchCollectionView.frame.width
                let height = 113.adjustedHeight
                
                return CGSize(width: width, height: height)
            case .emptyMusicPreview:
                let width = self.searchCollectionView.frame.width
                let height = self.searchCollectionView.frame.height
                
                return CGSize(width: width, height: height)
            }
        } else {
            let width = self.askQuestionCollectionView.frame.width
            let height = 360.adjustedHeight

            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
