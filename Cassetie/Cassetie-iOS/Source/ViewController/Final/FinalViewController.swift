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
            return cell
        }
    }
    
    let backgroundImage = UIImageView().then {
        $0.image = Image.backgroundImg
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
        
        noticeStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(90.adjustedHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(780.adjustedHeight)
            $0.centerY.equalToSuperview().offset(20)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        noticeStackView.addArrangedSubviews([noticeTopLabel, noticeBottomLabel])
        view.addSubviews([backgroundImage, noticeStackView, collectionView])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        collectionView.register(CassetieBoxCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CassetieBoxCollectionViewCell.self))
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        print(UIScreen.main.bounds.width)
//        print(UIScreen.main.bounds.width / 2.0)
//    }
    
    func bind(reactor: FinalReactor) {
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
