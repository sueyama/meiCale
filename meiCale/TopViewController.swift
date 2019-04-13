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
import UserNotifications

class TopViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let timerNotificationIdentifier = "id1"
    
    var meiCaleList = [Post]()
    
    var selectNumber:[String] = []
    var day:String = String()
    var month:String = String()
    var year:String = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topTableView.delegate = self
        topTableView.dataSource = self
        
        //選択した番号取得
        selectNumber = UserDefaults.standard.array(forKey: "famousUserList") as! [String]
        
        // ヘッダーを設定
        setHeader()
        
        //名言を取得するメソッド呼び出し
        getCalenderInfo()
        editUI()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setAlert()
    }
    
    func setAlert(){
        //通知飛ばしていいかの許可
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized){
                //知らせる
                self.push()
            }else{
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.badge,.alert], completionHandler: { (granted, error) in
                    if let error = error{
                        print(error)
                    }else{
                        if(granted){
                            self.push()
                        }
                    }
                })
            }
        }
    }
    
    func push(){
        // 通知内容の設定
        let content = UNMutableNotificationContent()
        content.title = "今日の名言が更新されました！"
        content.subtitle = self.meiCaleList[0].name
        content.body = self.meiCaleList[0].word
        content.sound = UNNotificationSound.default()
        
        let timerIconURL = Bundle.main.url(forResource: "topImage", withExtension: "jpg")
        //let timerIconURL = URL(string:self.meiCaleList[0].imageUrl as String)
        let attach = try! UNNotificationAttachment(identifier: timerNotificationIdentifier, url: timerIconURL!, options: nil)
        
        content.attachments.append(attach)
        //通知テスト用トリガー
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats:true)
        
        //毎日9時に通知
        let date = DateComponents(hour:9)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: timerNotificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            //エラー処理
            if let error = error{
                print(error)
            }else{
                print("配信されました！")
            }
        }
    }
    
    // フォアグラウンドの場合でも通知を表示する
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
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
                        if self.day == document.data()["day"] as? String{
                            self.meiCaleList.append(Post(number: (document.data()["number"] as? String)!,imageUrl:(document.data()["imageUrl"] as? String)!,word:(document.data()["word"] as? String)!,name:(document.data()["name"] as? String)!,day:(document.data()["day"] as? String)!))
                            
                            self.topTableView.reloadData()
                        }
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
        
        let image = UIImage(named: "star")

        likeButton.setImage(image, for: .normal)
        likeButton.accessibilityValue = "select"
        likeButton.accessibilityHint = self.meiCaleList[indexPath.row].number
        
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

        if sender.accessibilityValue! == "nonselect" {
            let image = UIImage(named: "star_selected")
            sender.setImage(image, for: .normal)
            sender.accessibilityValue = "selected"
            var favoriteWord = UserDefaults.standard.array(forKey: "favoriteWord") as! [(man: String, day: String)]
            favoriteWord.append((man: sender.accessibilityHint, day: self.day) as! (man: String, day: String))
            UserDefaults.standard.set(favoriteWord, forKey: "favoriteWord")

        } else {
            let image = UIImage(named: "star")
            sender.setImage(image, for: .normal)
            sender.accessibilityValue = "nonselect"

            var favoriteWord = UserDefaults.standard.array(forKey: "favoriteWord") as! [(man: String, day: String)]
            favoriteWord = favoriteWord.filter { !($0.man == sender.accessibilityHint && $0.day == self.day) }
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

/* ゴミ置き場 あとで削除
let buttonHeight = likeButton.bounds.height
let buttonWidth = likeButton.bounds.width
// ★のアニメーション
animationView.frame = CGRect(x:0, y:0, width:buttonWidth, height:buttonHeight)

likeButton.addSubview(animationView)

//Tagに「6」を振っている
let starView = cell.contentView.viewWithTag(6) as! UIView
starView.addSubview(animationView)

let animationView = LOTAnimationView(name: "favourite_app_icon.json")
 
animationView.play(fromProgress: 0, toProgress: 1,withCompletion: nil)
animationView.play(fromProgress: 0, toProgress: 0,withCompletion: nil)

*/
