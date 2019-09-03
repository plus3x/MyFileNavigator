//
//  Upload.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import Foundation

class Upload {
    let name: String
    let link: String
    
    required init(name: String, link: String) {
        self.name = name
        self.link = link
    }
}
