//
//  main.swift
//  APISample
//
//  Created by 森下 健 on 2014/12/07.
//  Copyright (c) 2014年 Yumemi. All rights reserved.
//

import Foundation

let config = MyAPIConfig(baseURL: "http://qiita.com/api/v2")
let apiFactory = MyAPIFactory(config: config)
let itemAPI = apiFactory.createMyAPIItem()

let queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)

println(1)
itemAPI.call(MyAPIItem.Params(), queue: queue) { (response, items) in
    println(Item.toJsonString(items, pritty: true))
}
println(2)

CFRunLoopRun()