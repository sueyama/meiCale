//
//  MyCustomeData.swift
//  meiCale
//
//  Created by 上山　俊佑 on 2018/11/24.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import Foundation

class MyCustomeData: NSObject {
    
    var name:String = String()          //有名人の名前
    var imageUrl:String! = String()      //有名人の写真
    var number:String = String()        //有名人の管理番号
    
    init(name: String, imageUrl: String?, number: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.number = number
    }
}
