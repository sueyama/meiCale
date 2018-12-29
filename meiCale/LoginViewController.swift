//
//  LoginViewController.swift
//  meiCale
//
//  Created by 上山　俊佑 on 2018/11/15.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import UIKit
import TwitterKit
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var poemLabel: KerningLabel!
    @IBOutlet weak var startButton: CustomButton!
    
    var username = String()
    
    override func viewDidLoad() {
        editUI()
    }

    @IBAction func login(_ sender: Any) {
        let okOrNot = UserDefaults.standard.string(forKey: "Choice")
        
        if okOrNot != "DONE"{
            UserDefaults.standard.set("DONE", forKey: "Choice")

            //人物選択画面へ
            self.performSegue(withIdentifier: "choice", sender: nil)

        }else{
            //名言画面へ
            //人物選択画面へ
            self.performSegue(withIdentifier: "choice", sender: nil)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func editUI(){
        super.viewDidLoad()
        // 行間調整
        let LineSpaceStyle = NSMutableParagraphStyle()
        LineSpaceStyle.lineSpacing = 15.0
        let lineSpaceAttr = [NSAttributedStringKey.paragraphStyle: LineSpaceStyle]
        poemLabel.attributedText = NSMutableAttributedString(string: poemLabel.text!, attributes: lineSpaceAttr)

        poemLabel.textAlignment = .center
        poemLabel.center = self.view.center
        
        // フェードイン
        titleLabel.fadeIn(duration:4)
        captionLabel.fadeIn(duration:4)
        poemLabel.fadeIn(duration:4)
        startButton.fadeIn(duration:4)
    }
}

enum FadeType: TimeInterval {
    case
    Normal = 0.5,
    Slow = 2
}

extension UIView {
    func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeIn(duration: type.rawValue, completed: completed)
    }
    
    /** For typical purpose, use "public func fadeIn(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeIn(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: duration,
                       animations: {
                        self.alpha = 1
        }) { finished in
            completed?()
        }
    }
    func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil) {
        fadeOut(duration: type.rawValue, completed: completed)
    }
    /** For typical purpose, use "public func fadeOut(type: FadeType = .Normal, completed: (() -> ())? = nil)" instead of this */
    func fadeOut(duration: TimeInterval = FadeType.Slow.rawValue, completed: (() -> ())? = nil) {
        UIView.animate(withDuration: duration
            , animations: {
                self.alpha = 0
        }) { [weak self] finished in
            self?.isHidden = true
            self?.alpha = 1
            completed?()
        }
    }
}
