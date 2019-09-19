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
    
    // Convenience function for short uploading stubs
    static func save(_ document: Document) {
        _ = DocumentSaver.save(document, with: nil)
    }
    
    static func save(_ document: Document, with data: Data? = nil) -> Bool {
        guard var documents = try? get() else { return false }
        
        if let data = data, !saveFile(of: document, with: data) {
            return false
        }
        
        if let savedDocument = documents.first(where: { $0.name == document.name }) {
            savedDocument.update(with: document)
        } else {
            documents.append(document)
        }
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: documents, requiringSecureCoding: false) {
            UserDefaults.standard.set(data, forKey: mainKey)
            UserDefaults.standard.synchronize()
        } else {
            return false
        }
        
        return true
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
    
    private static func saveFile(of document: Document, with data: Data) -> Bool {
        do {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = dir.appendingPathComponent(document.name)
            
            try data.write(to: filePath)
            
            document.filePath = filePath
            
            return true
        } catch {
            return false
        }
    }
}
