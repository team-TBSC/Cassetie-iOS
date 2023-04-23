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
import RxGesture

class FivthStoryTutorialViewController: BaseViewController {
    let backgroundView = UIImageView().then {
        $0.image = Image.tutorialFinal
    }
    
    let mentionView = TutorialMentionView(type: .fivth)
    
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
        
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: {_ in
                let searchViewController = SearchViewController(reactor: SearchReactor.init())
                self.navigationController?.pushViewController(searchViewController, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, mentionView])
    }
    
}

