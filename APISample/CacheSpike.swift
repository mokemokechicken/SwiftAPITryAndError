//
//  CacheSpike.swift
//  APISample
//
//  Created by 森下 健 on 2014/12/25.
//  Copyright (c) 2014年 Yumemi. All rights reserved.
//

import Foundation


public class QiitaCacheBase {
    private var cache = [String:Any]()
    public var enableCache = true
    
    func find(key: String) -> Any? {
        return self.cache[key]
    }
    
    public func clearCache() {
        self.cache.removeAll(keepCapacity: false)
    }
    
    func store(key: String, object: Any?) {
        if let o = object {
            if enableCache {
                self.cache[key] = o
            }
        }
    }
}


// QiitaItem
public class QiitaCacheItem : QiitaCacheBase {
    func store(key: String, object: [QiitaItem]?) {
        if let o = object {
            if enableCache {
                self.cache[key] = o
                for x in o { store(x) }
            }
        }
    }
    
    func store(object: QiitaItem?) {
        if let o = object {
            if enableCache {
                self.cache[String(o.id)] = o
            }
        }
    }
}
