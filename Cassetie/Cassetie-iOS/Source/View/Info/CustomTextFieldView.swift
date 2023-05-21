//
//  customTextFieldView.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/05/21.
//

import UIKit

import SnapKit
import Then

class CustomTextFieldView: BaseView {
    let label = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .white
    }
    
    let textField = UITextField().then {
        $0.borderStyle = .none
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 24, weight: .ultraLight)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let textFieldStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 13
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    init(labelText: String) {
        super.init(frame: .zero)
        self.label.text = labelText
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        textFieldStackView.addArrangedSubviews([lineView, textField])
        addSubviews([label, textFieldStackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(55)
            $0.width.equalTo(3)
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(5)
            $0.height.equalTo(70)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
