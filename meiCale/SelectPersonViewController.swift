//
//  SelectPersonViewController.swift
//  meiCale
//
//  Created by 上山　俊佑 on 2018/11/17.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class SelectPersonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var memberCollection: UICollectionView!
    
    var myCustomeData = [MyCustomeData]()
    
    var selectNumber:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editUI()
        // delegateを設定する
        self.memberCollection.dataSource = self
        self.memberCollection.delegate = self

        setInitData()

    }

    // カスタムセルの初期データはここで適当に与える
    func setInitData() {
        
        let db = Firestore.firestore()
        
        db.collection("famousUsers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in (querySnapshot?.documents)!{
                    
                    self.myCustomeData.append(MyCustomeData(name: (document.data()["name"] as? String)!,imageUrl:(document.data()["imageUrl"] as? String)!,number:(document.data()["number"] as? String)!))
                    
                    self.memberCollection.reloadData()

                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCustomeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //Cell1というIdentifierをつける
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath)
        
        //有名人の写真
        //Tagに「1」を振っている
        let userImageView = cell.contentView.viewWithTag(1) as! UIImageView
        //roomImageViewにタグを付ける
        let userImageUrl = URL(string:self.myCustomeData[indexPath.row].imageUrl as! String)!
        //Cashをとっている
        userImageView.sd_setImage(with: userImageUrl, completed: nil)
        
        //有名人の名前
        //Tagに「2」を振っている
        let userName = cell.contentView.viewWithTag(2) as! UILabel
        userName.text = self.myCustomeData[indexPath.row].name

        //チェックボックス
        //Tagに「3」を振っている
        let userCheckbox = cell.contentView.viewWithTag(3) as! BEMCheckBox
        userCheckbox.accessibilityValue = self.myCustomeData[indexPath.row].number
        userCheckbox.addTarget(self, action: #selector(onClickMySwicth), for: UIControlEvents.valueChanged)

        //userCheckbox.delegate = self as? BEMCheckBoxDelegate
        
        // セルのUIを調整
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.fadeIn(duration:0.7)
        return cell        
    }
    
    @objc func onClickMySwicth(_ sender: BEMCheckBox){
        if sender.on {
            selectNumber.append(sender.accessibilityValue!)
        }else {
            selectNumber.remove(at: selectNumber.index(of: sender.accessibilityValue!)!)
        }
    }
    
    @IBAction func selectFinish(_ sender: Any) {
        
        self.performSegue(withIdentifier: "top", sender: nil)

    }
    
    // 人物選択されていないの場合、画面遷移しない
    /// 画面遷移するかの判定処理
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.selectNumber.isEmpty {
            let errorMassage = "人物を１人以上選択して下さい"
            showErrorMassage(massage : errorMassage)
            
            return false;
            
        }
        return true;
    }

    /// 画面遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //選択された時に選択されているCellのnumberを保存
        UserDefaults.standard.set(self.selectNumber, forKey: "famousUserList")
    }
    
    func showErrorMassage(massage : String){
        // UIAlertControllerを生成
        let alui = UIAlertController(title: "入力エラー", message: massage, preferredStyle: UIAlertControllerStyle.alert)
        // 選択肢としてContinueボタンを用意する
        let btn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alui.addAction(btn)
        present(alui, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Screenサイズに応じたセルサイズを返す
    // UICollectionViewDelegateFlowLayoutの設定が必要
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 2
        let cellSize:CGFloat = self.view.bounds.width/2 - horizontalSpace - 20
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
    func editUI(){
    }
}
