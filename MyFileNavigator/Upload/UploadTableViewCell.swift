//
//  UploadTableViewCell.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class UploadTableViewCell: UITableViewCell {

    @IBOutlet weak var uploadLabel: UILabel!
    
    var upload: Upload!

    func configure(with upload: Upload) {
        self.upload = upload
        
        uploadLabel.text = upload.name
    }
    
}
