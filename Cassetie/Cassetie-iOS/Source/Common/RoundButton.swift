//
//  RoundButton.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/10.
//

import UIKit

import SnapKit
import Then

class RoundButton: UIButton {
    // MARK: - Propertie
    init(title: String, titleColor: UIColor, backColor: UIColor, round: CGFloat) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 24, weight: .light)
        backgroundColor = backColor
        cornerRound(radius: round)
    }
    
    func configureFont(font: UIFont) {
        titleLabel?.font = font
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

