//
//  Person.swift
//  Tut10
//
//  Created by nickvido on 10/14/15.
//  Copyright © 2015 nickvido. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image:String) {
        self.name = name
        self.image = image
    }
}
