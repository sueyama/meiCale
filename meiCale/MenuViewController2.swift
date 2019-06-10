//
//  MenuViewController2.swift
//  meiCale
//
//  Created by 上山　俊佑 on 2019/05/01.
//  Copyright © 2019 Shunsuke Ueyama. All rights reserved.
//

import UIKit

class MenuViewController2: UIViewController {
    
    @IBOutlet var menuView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // メニューの位置を取得する
        let menuPos = self.menuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.menuView.layer.position.x = self.menuView.frame.width + self.view.frame.size.width
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
        
    }
    
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = self.menuView.frame.width + self.view.frame.size.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        // メニューの位置を取得する
        let menuPos = self.menuView.layer.position
        
        self.menuView.layer.position.x = menuPos.x
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = self.menuView.frame.width + self.view.frame.size.width
        },
            completion: { bool in
        })
    }
    
    
    @IBAction func topGamen(_ sender: Any) {
        //TOP画面へ
        self.performSegue(withIdentifier: "top", sender: nil)
    }
    
    
    @IBAction func manChoice(_ sender: Any) {
        //人物選択画面へ
        self.performSegue(withIdentifier: "choiceBacked", sender: nil)
    }
    
    
    @IBAction func infoPolicy(_ sender: Any) {
        let url = URL(string: "http://meicale.weblike.jp/privacy-policy/")
        // iOS 10以降利用可能
        UIApplication.shared.open(url!)
    }
    
    
    @IBAction func alertSettingButtonTouchDown(_ sender: Any) {
        print("cliked!")
        // OSの通知設定画面へ遷移
        if let url = URL(string:"App-Prefs:root=NOTIFICATIONS_ID&path={com.littletips.meiCale}") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
