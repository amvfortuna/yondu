//
//  Config.swift
//  Yondu
//
//  Created by Anna Fortuna on 07/11/2016.
//  Copyright © 2016 AVF. All rights reserved.
//

import Foundation

class Config {
    static let sharedInstance = Config()
    fileprivate let configurations: NSDictionary!
    fileprivate(set) var urls: [String]!
    
    init() {
        let buildConfiguration = Bundle.main.object(forInfoDictionaryKey: "Build Configuration")!
        let configFile = Bundle.main.path(forResource: "Configurations", ofType: "plist")!
        self.configurations = NSDictionary(contentsOfFile: configFile)!.object(forKey: buildConfiguration) as! NSDictionary!
        self.urls = self.configurations.object(forKey: "URLs") as! [String]
    }
    
    func log(_ message: String) {
        if self.configurations.object(forKey: "Logging") as! Bool == true {
            print(message)
        }
    }
}
