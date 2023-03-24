//
//  NsMutableAttributedString+.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/03.
//

import UIKit

extension NSMutableAttributedString {
    func bold(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func regular(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func light(string: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize, weight: .light)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
