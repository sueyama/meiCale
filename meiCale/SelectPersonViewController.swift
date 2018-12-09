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
        cell.fadeIn(type:.Normal)
        return cell        
    }
    
    @objc func onClickMySwicth(_ sender: BEMCheckBox){
        if sender.on {
            selectNumber.append(sender.accessibilityValue!)
            //↓トップページに遷移できないので一時的に処置。後で削除
            UserDefaults.standard.set(self.selectNumber, forKey: "famousUserList")
        }else {
            selectNumber.remove(at: selectNumber.index(of: sender.accessibilityValue!)!)
        }
    }
    
    @IBAction func selectFinish(_ sender: Any) {
        //選択された時に選択されているCellのnumberを保存
        UserDefaults.standard.set(self.selectNumber, forKey: "famousUserList")
        
        self.performSegue(withIdentifier: "top", sender: nil)
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
