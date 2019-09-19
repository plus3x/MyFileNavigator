//
//  DocumentPreviewController.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 18/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit
import QuickLook

class DocumentPreviewController: QLPreviewController {
    var documents = [Document]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        view.backgroundColor = .black
    }
}

extension DocumentPreviewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return documents.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return documents[index].filePath! as QLPreviewItem
    }
}
