//
//  adjusted+.swift
//  Cassetie-iOS
//
//  Created by Sojin Lee on 2023/03/05.
//

import UIKit

extension CGFloat {
    var adjustedWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 834
        return ratio * CGFloat(self)
    }
    
    var adjustedHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 1194
        return ratio * CGFloat(self)
    }
}

extension Int {
    var adjustedWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 834
        return ratio * CGFloat(self)
    }
    
    var adjustedHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 1194
        return ratio * CGFloat(self)
    }
}

extension Double {
    var adjustedWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 834
        return ratio * CGFloat(self)
    }
    
    var adjustedHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 1194
        return ratio * CGFloat(self)
    }
}
