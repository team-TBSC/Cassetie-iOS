//
//  Color.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/02/22.
//

import UIKit.UIColor

enum Color {
    static let grayL = UIColor("292541")
    static let grayD = UIColor("1C1C1C")
    static let grayDL = UIColor("7A839B")
    static let navyD = UIColor("292541")
    static let navyL = UIColor("3E3754")
}

fileprivate extension UIColor {
    convenience init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
