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

    @IBOutlet weak var poemLabel: KerningLabel!

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
        let LineSpaceStyle = NSMutableParagraphStyle()
        LineSpaceStyle.lineSpacing = 15.0
        let lineSpaceAttr = [NSAttributedStringKey.paragraphStyle: LineSpaceStyle]
        poemLabel.attributedText = NSMutableAttributedString(string: poemLabel.text!, attributes: lineSpaceAttr)
        poemLabel.textAlignment = .center
        poemLabel.center = self.view.center

    }
}

