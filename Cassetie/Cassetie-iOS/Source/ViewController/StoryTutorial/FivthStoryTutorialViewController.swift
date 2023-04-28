//
//  FivthStoryTutorialViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/04/06.
//

import UIKit

import SnapKit
import Then
import RxSwift

class FivthStoryTutorialViewController: BaseViewController {
    private let backgroundView = UIImageView().then {
        $0.image = Image.tutorialFinal
    }
    
    private let mentionView = TutorialMentionView(type: .fivth)
    private let tapGesture = UITapGestureRecognizer()
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mentionView.snp.makeConstraints {
            $0.width.equalTo(713.adjustedWidth)
            $0.height.equalTo(245.adjustedHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(70)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        tapGesture.rx.event
            .subscribe(onNext: { _ in
                let searchViewController = RootSwitcher.search.page //SearchViewController(reactor: SearchReactor.init())
                self.navigationController?.pushViewController(searchViewController, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        view.addGestureRecognizer(tapGesture)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, mentionView])
    }
    
}

