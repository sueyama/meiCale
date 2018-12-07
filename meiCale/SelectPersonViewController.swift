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

class SelectPersonViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var memberCollection: UICollectionView!
    
    var myCustomeData = [MyCustomeData]()
    
    var selectNumber:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        //選択された時に選択されているCellのnumberを保存
        UserDefaults.standard.set(self.selectNumber, forKey: "famousUserList")
        
        self.performSegue(withIdentifier: "top", sender: nil)
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
