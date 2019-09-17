//
//  DocumentTableViewCell.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    static let identifier = "DownloadsTableViewCellIdentifier"
    
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var document: Document!
    
    func configure(with document: Document) {
        self.document = document
        
        documentLabel.text = document.name
        sizeLabel.text = String(format: "%.2fMB", Double(document.data?.count ?? 0) / 1024 / 1024)
    }
}
