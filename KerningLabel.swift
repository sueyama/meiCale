//
//  KerningLabel.swift
//  meiCale
//
//  Created by 北川雄太 on 2018/12/09.
//  Copyright © 2018 Shunsuke Ueyama. All rights reserved.
//

import UIKit

class KerningLabel: UILabel {

    @IBInspectable var kerning: CGFloat = 0.0 {
        didSet {
            if let attributedText = self.attributedText {
                let attribString = NSMutableAttributedString(attributedString: attributedText)
                attribString.addAttributes([.kern: kerning], range: NSRange(location: 0, length: attributedText.length))
                self.attributedText = attribString
            }
        }
    }

}
