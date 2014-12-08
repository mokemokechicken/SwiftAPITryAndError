//
//  main.swift
//  APISample
//
//  Created by 森下 健 on 2014/12/07.
//  Copyright (c) 2014年 Yumemi. All rights reserved.
//

import Foundation

private let config = MyAPIConfig(baseURL: NSURL(string: "http://qiita.com/api/v2")!)
private let apiFactory = MyAPIFactory(config: config)
private let itemAPI = apiFactory.createMyAPIItem()

itemAPI.call(MyAPIItem.Params()) { (response, items) in
    if let sureItems = items {
        println(Item.toJsonString(sureItems, pritty: true))
    } else {
        println("Items parse error")
    }
}

CFRunLoopRun()