//
//  OrderModel.swift
//  login_test
//
//  Created by Katherine Myers on 2017-10-19.
//  Copyright © 2017 Katherine Myers. All rights reserved.
//

import UIKit

class MenuItem: NSObject {
    var name = "None"
    var special = false
    override init(){}
    init(name:String,price:Double,special:Bool){
        self.name = name
        self.special = special
    }
}
