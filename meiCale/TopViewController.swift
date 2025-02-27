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
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var meiCaleList = [Post]()
    
    var selectNumber:[String] = []
    var day:String = String()
    var month:String = String()
    var year:String = String()
    
    // アニメーションのviewを生成
    let animationView = LOTAnimationView(name: "favourite_app_icon.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTableView.delegate = self
        topTableView.dataSource = self

        //選択した番号取得
        selectNumber = UserDefaults.standard.array(forKey: "famousUserList") as! [String]
        print(selectNumber)
        
        // ヘッダーを設定
        setHeader()
        
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
        //背景色をグレーに設定
        cell.contentView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        //名言
        //Tagに「1」を振っている
        let sayingLabel = cell.contentView.viewWithTag(1) as! UILabel
        sayingLabel.text = self.meiCaleList[indexPath.row].word
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
        let image = UIImage(named: "star")
        //likeButton.setImage(image, for: .normal)
        likeButton.accessibilityValue = "nonselect"
        likeButton.accessibilityHint = self.meiCaleList[indexPath.row].number
        
        likeButton.addTarget(self, action: #selector(onClickMySwicth), for: UIControlEvents.touchDown)
        
        // スターをViewControllerに配置
        self.view.addSubview(animationView)

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
        yearLabel.text = self.year
        let monthEnglish = editMonth()
        monthLabel.text = monthEnglish
        dateLabel.text = self.day
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
    func editMonth() -> String{
        
        var monthEnglish:String = String()
        switch (month) {
            case "1": monthEnglish = "January"; break;
            case "2": monthEnglish = "February"; break;
            case "3": monthEnglish = "March"; break;
            case "4": monthEnglish = "April"; break;
            case "5": monthEnglish = "May"; break;
            case "6": monthEnglish = "June"; break;
            case "7": monthEnglish = "July"; break;
            case "8": monthEnglish = "August"; break;
            case "9": monthEnglish = "September"; break;
            case "10": monthEnglish = "October"; break;
            case "11": monthEnglish = "November"; break;
            case "12": monthEnglish = "December"; break;
            default: monthEnglish = "NaN"; break;
        }
        return monthEnglish
    }

}
