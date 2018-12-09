//
//  CustomButton.swift
//  meiCale
//
//  Created by 北川雄太 on 2018/12/09.
//  Copyright © 2018 Shunsuke Ueyama. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
