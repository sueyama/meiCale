//
//  TopViewController.swift
//  meiCale
//
//  Created by 上山　俊佑 on 2018/12/02.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SDWebImage
import Lottie

class TopViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var topTableView: UITableView!
    
    var meiCaleList = [Post]()
    
    var selectNumber:[String] = []
    var day:String = String()
    
    // アニメーションのviewを生成
    let animationView = LOTAnimationView(name: "favourite_app_icon.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTableView.delegate = self
        topTableView.dataSource = self

        //選択した番号取得
        selectNumber = UserDefaults.standard.array(forKey: "famousUserList") as! [String]
        print(selectNumber)
        // 今日の日付を取得
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendar.locale = Locale(identifier: "ja")
        self.day = String(calendar.component(.day, from: date))

        //名言を取得するメソッド呼び出し
        getCalenderInfo()
        editUI()


    }

    //ルームのデータ取得メソッド
    func getCalenderInfo(){
        
        let db = Firestore.firestore()
        
        db.collection("meiCaleList").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in (querySnapshot?.documents)!{
                    if self.selectNumber.contains((document.data()["number"] as? String)!){
                        self.meiCaleList.append(Post(number: (document.data()["number"] as? String)!,imageUrl:(document.data()["imageUrl"] as? String)!,word:(document.data()["word"] as? String)!,name:(document.data()["name"] as? String)!))
                        
                        self.topTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移
        //performSegue(withIdentifier: "joinChat", sender: indexPath)
        
    }
    
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        
//        let joinChatVC = segue.destination as! JoinChatViewController
//
//        //RoomIDを渡したい
//        joinChatVC.roomID = self.seni_roomID
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell1というIdentifierをつける
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
        
        //写真
        //Tagに「1」を振っている
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        //ownernameにタグを付ける
        let imageUrl = URL(string:self.meiCaleList[indexPath.row].imageUrl as String)!
        //Cashをとっている
        imageView.sd_setImage(with: imageUrl, completed: nil)
        
        //名言
        //Tagに「2」を振っている
        let roomNameLabel = cell.contentView.viewWithTag(2) as! UITextView
        roomNameLabel.text = self.meiCaleList[indexPath.row].word
        
        //日にち
        //Tagに「3」を振っている
        let dateLabel = cell.contentView.viewWithTag(3) as! UILabel
        dateLabel.text = self.day

        //名前
        //Tagに「4」を振っている
        let nameLabel = cell.contentView.viewWithTag(4) as! UILabel
        nameLabel.text = self.meiCaleList[indexPath.row].name

        //お気にいり(スター)
        //Tagに「5」を振っている
        let likeButton = cell.contentView.viewWithTag(5) as! UIButton
        let image = UIImage(named: "star")
        //likeButton.setImage(image, for: .normal)
        likeButton.accessibilityValue = "nonselect"
        likeButton.accessibilityHint = self.meiCaleList[indexPath.row].number
        
        likeButton.addTarget(self, action: #selector(onClickMySwicth), for: UIControlEvents.touchDown)
        
        // スターをViewControllerに配置
        self.view.addSubview(animationView)


        return cell
    }
    // 画像がタップされたら呼ばれる
    @objc func onClickMySwicth(_ sender: UIButton){
        print(sender.accessibilityHint!)

        if sender.accessibilityValue! == "nonselect" {
            animationView.play(fromProgress: 0, toProgress: 1,withCompletion: nil)
            let image = UIImage(named: "star_selected")
            sender.setImage(image, for: .normal)
            sender.accessibilityValue = "selected"

        } else {
            animationView.play(fromProgress: 0, toProgress: 0,withCompletion: nil)
            let image = UIImage(named: "star")
            sender.setImage(image, for: .normal)
            sender.accessibilityValue = "nonselect"
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meiCaleList.count
    }
    
    // Cell の高さを60にする
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height
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
    func editUI(){

    }
}
