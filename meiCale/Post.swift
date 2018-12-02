//
//  Post.swift
//  shallWe
//
//  Created by 上山　俊佑 on 2018/06/09.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import UIKit

class Post: NSObject {

    var number:String = String()
    var word:String = String()
    var imageUrl:String = String()
    var name:String = String()
    
    init(number: String, imageUrl: String?, word: String, name: String) {
        self.number = number
        self.imageUrl = imageUrl!
        self.word = word
        self.name = name
    }

}
