//
//  InfoViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/05/21.
//

import UIKit

import SnapKit
import Then
import ReactorKit
import RxDataSources
import RxViewController

class InfoViewController: BaseViewController, View {
    typealias Reactor = InfoReactor
    
    private let blurEffect = UIBlurEffect(style: .dark)
    private lazy var backgroundEffectView = UIVisualEffectView(effect: self.blurEffect)

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
        $0.text = "방명록을 작성해주세요."
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .white
    }
    private let noticeBottomLable = UILabel().then {
        $0.text = "거의 다 왔어요!"
        $0.font = .systemFont(ofSize: 24, weight: .light)
        $0.textColor = .white
    }
    
    private let nameTextField = CustomTextFieldView(labelText: "이름")
    private let mentionTextField = CustomTextFieldView(labelText: "오늘의 한 마디")
    
    private let infoStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private let goToLoadingButton = RoundButton(
        title: "카세티 보러가기!",
        titleColor: .black,
        backColor: .white,
        round: 40
    )
    
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
        
        goToLoadingButton.snp.makeConstraints {
            $0.width.equalTo(370)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(53)
        }
        
        nameTextField.snp.makeConstraints {
            $0.width.equalTo(470)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(135)
            $0.top.equalTo(noticeStackView.snp.bottom).offset(30)
        }
        
        mentionTextField.snp.makeConstraints {
            $0.width.equalTo(470)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(135)
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        noticeStackView.addArrangedSubviews([noticeTopLable, noticeBottomLable])
        
        backgroundView.addSubviews([noticeStackView, nameTextField, mentionTextField, goToLoadingButton])
        view.addSubviews([backgroundEffectView, backgroundView])
    }
    
    func bind(reactor: InfoReactor) {
        goToLoadingButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: false)
                let loadingViewController = RootSwitcher.loading.page
                self?.navigationController?.pushViewController(loadingViewController, animated: false)
                
                reactor.action.onNext(.post)
            })
            .disposed(by: disposeBag)
        
        nameTextField.textField.rx.text
            .compactMap { $0 }
            .skip(1)
            .distinctUntilChanged()
            .map { text in Reactor.Action.updateName(text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mentionTextField.textField.rx.text
            .compactMap { $0 }
            .skip(1)
            .distinctUntilChanged()
            .map { text in Reactor.Action.updateMentionText(text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
