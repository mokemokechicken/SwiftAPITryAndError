//
//  main.swift
//  APISample
//
//  Created by 森下 健 on 2014/12/07.
//  Copyright (c) 2014年 Yumemi. All rights reserved.
//

import Foundation

private let config = QiitaAPIConfig(baseURL: NSURL(string: "http://qiita.com/api/v2/")!)
private let apiFactory = QiitaAPIFactory(config: config)

apiFactory.createListItem().setup().call { res, items in
    if let sureItems = items {
        println(QiitaItem.toJsonString(sureItems, pretty: true))
    } else {
        println("Items parse error")
    }
}

//itemAPI.setup().call() { (response, items) in
//    if let sureItems = items {
//        println(Item.toJsonString(sureItems, pritty: true))
//    } else {
//        println("Items parse error")
//    }
//}

CFRunLoopRun()