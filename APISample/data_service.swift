//
//  data_service.swift
//  APISample
//
//  Created by 森下 健 on 2014/12/10.
//  Copyright (c) 2014年 Yumemi. All rights reserved.
//

import Foundation

public class DataService<ET:AnyObject> {
    public typealias ET = QiitaItem
    public typealias Handler = (ET) -> Void
    private var observers = [(AnyObject,Handler)]()
    let factory: QiitaAPIFactory
    
    public func addObserver(object: AnyObject, handler: Handler) {
        observers.append((object, handler))
    }
    
    public func removeObserver(object: AnyObject) {
        observers = observers.filter { $0.0 !== object}
    }
    
    private func observedBy(object: AnyObject) -> Bool {
        for o in observers {
            if o.0 === object {
                return true
            }
        }
        return false
    }
    
    public func notify(data: ET) {
        for observer in observers {
            observer.1(data)
        }
    }
    
    public func get(params: AnyObject) -> ET? {
        return nil
    }
    
    public init(factory: QiitaAPIFactory) {
        self.factory = factory
    }
    
    public func requestBy(client: AnyObject, id: String, body: AnyObject, handler: (NSError?, ET?) -> Void) {
        factory.createGetItem().setup(id: id).call { res, item in
            if self.observedBy(client) {
                handler(res.error, item)
            }
            if let e = item {
                self.notify(e)
            }
        }
    }
}


