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
private let locator = QiitaDSLocator(factory: apiFactory)

class Sample {
    func run() {
        let listItem = locator.ListItem
        println(listItem.data()) // fetch from cache
        
        listItem.addObserver(self) { items, error in
            items?.map { item in println(item.title) }
            println(listItem.data(perPage: 3)!.count)
            println(listItem.data(perPage: 4)?.count)
        }
        
        listItem.request(perPage: 3)
//        listItem.removeObserver(self)
    }
    
    deinit {
        NSLog("\(self) deinit")
    }
}

Sample().run()
CFRunLoopRun()
