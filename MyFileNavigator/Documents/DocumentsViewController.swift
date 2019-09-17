//
//  DocumentsViewController.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit
import QuickLook

class DocumentsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var documents = [Document]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let documents = try? DocumentSaver.get() {
            self.documents = documents.filter([.downloaded])
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(fileDidUpload(_:)), name: .fileUploaded, object: nil)
    }
    
    @objc private func fileDidUpload(_ notification: Notification) {
        if let document = notification.object as? Document {
            documents.append(document)
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.reloadData()
                })
            }
        }
    }
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifier, for: indexPath) as! DocumentTableViewCell
        
        cell.configure(with: documents[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let qlvc = QLPreviewController()
        qlvc.delegate = self
        qlvc.dataSource = self
        qlvc.view.backgroundColor = .black
        qlvc.currentPreviewItemIndex = indexPath.row
        present(qlvc, animated: true, completion: nil)
    }
}

extension DocumentsViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return documents.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let document = documents[index]
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(document.name)
        
        do {
            try document.data?.write(to: tempURL)
        } catch {
            // do nothing
        }
        
        return tempURL as QLPreviewItem
    }
}
