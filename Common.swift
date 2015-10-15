//
//  Common.swift
//  Tut10
//
//  Created by nickvido on 10/14/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import Cocoa

class Common {
    static func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
}
