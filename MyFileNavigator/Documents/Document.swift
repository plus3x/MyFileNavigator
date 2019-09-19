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
    var filePath: URL?
    var progress: Progress?
    var state: State = .downloadable
    var taskIdentifier: Int?
    
    init(name: String,
         url: String,
         filePath: URL? = nil,
         progress: Progress? = nil,
         state: State = .downloadable,
         taskIdentifier: Int? = nil) {
        self.name = name
        self.url = url
        self.filePath = filePath
        self.progress = progress
        self.state = state
        self.taskIdentifier = taskIdentifier
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let url = aDecoder.decodeObject(forKey: "url") as! String
        let filePath = aDecoder.decodeObject(forKey: "filePath") as? URL
        let taskIdentifier = aDecoder.decodeObject(forKey: "taskIdentifier") as? Int
        let state = Document.encodeState(coder: aDecoder)
        
        self.init(
            name: name,
            url: url,
            filePath: filePath,
            state: state,
            taskIdentifier: taskIdentifier
        )
    }
    
    private static func encodeState(coder aDecoder: NSCoder) -> State {
        let rawValue = aDecoder.decodeObject(forKey: "stateRawValue") as? String
        
        return State(rawValue: rawValue ?? "") ?? State.downloadable
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(filePath, forKey: "filePath")
        aCoder.encode(taskIdentifier, forKey: "taskIdentifier")
        aCoder.encode(state.rawValue, forKey: "stateRawValue")
    }
    
    func update(with document: Document) {
        filePath = document.filePath
        progress = document.progress
        state = document.state
        taskIdentifier = document.taskIdentifier
    }
}
