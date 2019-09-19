//
//  DocumentTableViewCell.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

extension URL {
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
}

class DocumentTableViewCell: UITableViewCell {
    static let identifier = "DownloadsTableViewCellIdentifier"
    
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var document: Document!
    
    func configure(with document: Document) {
        self.document = document
        
        documentLabel.text = document.name
        sizeLabel.text = document.filePath?.fileSizeString
    }
}
