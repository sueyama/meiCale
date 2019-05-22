//
//  FavoriteListViewController.swift
//  meiCale
//
//  Created by 上山　俊佑 on 2019/03/29.
//  Copyright © 2019 Shunsuke Ueyama. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SDWebImage
import Lottie
import UserNotifications


class FavoriteListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topTableView: UITableView!
    
    var meiCaleList = [Post]()
    
    var favoriteWord:[[String: String]] = []
    var day:String = String()
    var month:String = String()
    var year:String = String()
    
    var man:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTableView.delegate = self
        topTableView.dataSource = self
        
        //お気に入り名言
        // favoriteWordの存在チェック、初期値設定
        if UserDefaults.standard.object(forKey: "favoriteWord") != nil {
            
            //お気に入り名言
            favoriteWord = (UserDefaults.standard.array(forKey: "favoriteWord") as? [[String: String]])!
            
        }

        // ヘッダーを設定
        setHeader()
        
        //名言を取得するメソッド呼び出し
        getCalenderInfo()
        editUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //ルームのデータ取得メソッド
    func getCalenderInfo(){
        
        let db = Firestore.firestore()
        
        db.collection("meiCaleList").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in (querySnapshot?.documents)!{
                    if let ok =  self.favoriteWord.index(where: {($0["man"] == document.data()["number"] as? String && $0["day"] == document.data()["day"] as? String)}){
                        self.meiCaleList.append(Post(number: (document.data()["number"] as? String)!,imageUrl:(document.data()["imageUrl"] as? String)!,word:(document.data()["word"] as? String)!,name:(document.data()["name"] as? String)!,day:(document.data()["day"] as? String)!))
                        
                        self.topTableView.reloadData()
                        
                    }
                }
            }
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue,sender:Any?){
        
        //        let joinChatVC = segue.destination as! JoinChatViewController
        //
        //        //RoomIDを渡したい
        //        joinChatVC.roomID = self.seni_roomID
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移
        //performSegue(withIdentifier: "joinChat", sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell1というIdentifierをつける
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
        // 選択時の色をなしに設定
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //背景色をグレーに設定
        cell.contentView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        //名言
        //Tagに「1」を振っている
        let sayingLabel = cell.contentView.viewWithTag(1) as! UILabel
        sayingLabel.text = self.meiCaleList[indexPath.row].word
        
        //フォントサイズを調整
        sayingLabel.adjustsFontSizeToFitWidth = true
        sayingLabel.minimumScaleFactor = 0.3
        
        //名前
        //Tagに「2」を振っている
        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        nameLabel.text = self.meiCaleList[indexPath.row].name
        
        
        
        //写真
        //Tagに「3」を振っている
        let imageView = cell.contentView.viewWithTag(3) as! UIImageView
        
        let imageUrl = URL(string:self.meiCaleList[indexPath.row].imageUrl as String)!
        //Cashをとっている
        imageView.sd_setImage(with: imageUrl, completed: nil)
        
        //お気にいり(スター)
        //Tagに「4」を振っている
        let likeButton = cell.contentView.viewWithTag(4) as! UIButton
        
        let image = UIImage(named: "star_selected")
        
        likeButton.setImage(image, for: .normal)
        likeButton.accessibilityValue = "select"
        likeButton.accessibilityHint = self.meiCaleList[indexPath.row].number
        likeButton.accessibilityLabel = self.meiCaleList[indexPath.row].day
        
        likeButton.addTarget(self, action: #selector(onClickMySwicth), for: UIControlEvents.touchDown)
        
        //外枠
        //Tagに「5」を振っている
        let outerFlame = cell.contentView.viewWithTag(5) as! UIView
        outerFlame.layer.borderColor = UIColor.lightGray.cgColor
        outerFlame.layer.borderWidth = 1
        outerFlame.layer.cornerRadius = 5
        outerFlame.layer.masksToBounds = true
        
        return cell
    }
    // 画像がタップされたら呼ばれる
    @objc func onClickMySwicth(_ sender: UIButton){
        print(sender.accessibilityHint!)
        
        if sender.accessibilityValue! == "nonselect" {
            let image = UIImage(named: "star_selected")
            sender.setImage(image, for: .normal)
            sender.accessibilityValue = "select"
            if UserDefaults.standard.array(forKey: "favoriteWord") != nil {
                favoriteWord = (UserDefaults.standard.array(forKey: "favoriteWord") as? [[String: String]])!
            }
            favoriteWord.append(["man": sender.accessibilityHint!, "day": sender.accessibilityLabel!])
            
            UserDefaults.standard.set(favoriteWord, forKey: "favoriteWord")
            
        } else {
            let image = UIImage(named: "star")
            sender.setImage(image, for: .normal)
            sender.accessibilityValue = "nonselect"
            
            if UserDefaults.standard.array(forKey: "favoriteWord") != nil {
                favoriteWord = (UserDefaults.standard.array(forKey: "favoriteWord") as? [[String: String]])!
            }
            favoriteWord = favoriteWord.filter { !($0["man"] == sender.accessibilityHint && $0["day"] == sender.accessibilityLabel!) }
            
            UserDefaults.standard.set(favoriteWord, forKey: "favoriteWord")

        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meiCaleList.count
    }
    
    // Cell の高さを画面サイズに応じて調整する
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height - 170
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
    
    func setHeader(){
        getDate()
    }
    // 今日の年月日を取得し格納
    func getDate(){
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendar.locale = Locale(identifier: "ja")
        self.day = String(calendar.component(.day, from: date))
        self.month = String(calendar.component(.month, from: date))
        self.year = String(calendar.component(.year, from: date))
        
    }
    
}
