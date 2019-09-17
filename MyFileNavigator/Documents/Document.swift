//
//  Document.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import Foundation

extension Array where Element: Document {
    func filter(_ states: [Document.State]) -> [Element] {
        return self.filter({ states.contains($0.state) })
    }
}

class Document: NSObject, NSCoding {
    enum State: String {
        case downloadable, downloading, downloaded
    }
    
    let name: String
    let url: String
    var data: Data?
    var progress: Progress?
    var state: State = .downloadable
    
    init(name: String,
         url: String,
         data: Data? = nil,
         progress: Progress? = nil,
         state: State = .downloadable) {
        self.name = name
        self.url = url
        self.data = data
        self.progress = progress
        self.state = state
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let url = aDecoder.decodeObject(forKey: "url") as! String
        let data = aDecoder.decodeObject(forKey: "data") as? Data
        let progress = aDecoder.decodeObject(forKey: "progress") as? Progress
        let state = Document.encodeState(coder: aDecoder)
        
        self.init(name: name, url: url, data: data, progress: progress, state: state)
    }
    
    private static func encodeState(coder aDecoder: NSCoder) -> State {
        let rawValue = aDecoder.decodeObject(forKey: "stateRawValue") as? String
        
        return State(rawValue: rawValue ?? "") ?? State.downloadable
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(data, forKey: "data")
//        aCoder.encode(progress, forKey: "progress")
        aCoder.encode(state.rawValue, forKey: "stateRawValue")
    }
}
