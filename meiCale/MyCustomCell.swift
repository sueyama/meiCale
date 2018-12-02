//
//  MyCustomCell.swift
//  meiCale
//
//  Created by 上山　俊佑 on 2018/11/24.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import UIKit

class MyCustomCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var box: BEMCheckBox!
    @IBOutlet var uiImageUrl: UIImageView!
    
    var cellNumber: String = ""
    var numList: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    func setCell(myCustomData: MyCustomeData) {
        //有名人の名前
        self.nameLabel.text = myCustomData.name as String

        //有名人の写真
        let imageData = URL(string:myCustomData.imageUrl! as String)!

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageData) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.uiImageUrl.image = UIImage(data: data!)
            }
        }

        // cell number
        self.cellNumber = myCustomData.number
    
    }
    
    @IBAction func checkBox(_ sender: Any) {
        if UserDefaults.standard.object(forKey: self.cellNumber) as! String == self.cellNumber{ // -> true
            UserDefaults.standard.set("", forKey: self.cellNumber)
        }else{
            UserDefaults.standard.set(self.cellNumber, forKey: self.cellNumber)
        }
    }
}
