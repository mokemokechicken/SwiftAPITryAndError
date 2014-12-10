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

apiFactory.createListItem().setup(perPage: 3).call { res, items in
    items?.map { item in
        println("\(item.user.id): \(item.title)")
    }
    return
}

CFRunLoopRun()
