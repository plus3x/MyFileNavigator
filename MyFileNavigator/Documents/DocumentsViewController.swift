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
        
        DispatchQueue.main.async {
            guard let documents = try? DocumentSaver.get() else { return }
            
            self.documents = documents.filter([.downloaded])
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ncd = NotificationCenter.default
        ncd.addObserver(self, selector: #selector(didFileUpload(_:)), name: .didFileUpload, object: nil)
    }
    
    @objc private func didFileUpload(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let document = userInfo["document"] as? Document else {
            return
        }
        
        documents.append(document)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.documents.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
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
        
        let qlvc = DocumentPreviewController()
        qlvc.documents = documents
        qlvc.currentPreviewItemIndex = indexPath.row
        present(qlvc, animated: true, completion: nil)
    }
}
