//
//  DocumentSaver.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 04/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class DocumentSaver {
    static let mainKey = "Documents"
    
    static func cleanAll() {
        UserDefaults.standard.removeObject(forKey: mainKey)
    }
    
    static func save(_ document: Document) {
        if var documents = try? get() {
            // Duplicate removal
            documents.removeAll(where: { $0.name == document.name })
            
            documents.append(document)
            
            let data = try? NSKeyedArchiver.archivedData(withRootObject: documents, requiringSecureCoding: false)
            
            UserDefaults.standard.set(data, forKey: mainKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func get() throws -> [Document] {
        if let data = UserDefaults.standard.object(forKey: mainKey) as? Data,
           let records = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Document] {
            return records
        } else {
            return []
        }
    }
    
    static private func decodeRecords() -> Data {
        return Data()
    }
    
    static private func encodeRecords() -> [Document] {
        return [Document]()
    }
}
