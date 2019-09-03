//
//  DocumentTableViewCell.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    var document: Document!

    @IBOutlet weak var documentLabel: UILabel!
    
    func configure(with document: Document) {
        self.document = document
        
        documentLabel.text = document.name
    }
}
