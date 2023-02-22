//
//  SearchViewController.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/02/22.
//

import UIKit
import SnapKit
import Then

class SearchViewController: BaseViewController {
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
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([backgroundView, searchBackgroundView, searchBarBackgrundView, searchIcon, textField])
    }
   
}
