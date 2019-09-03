//
//  DocumentsViewController.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController {
    var documents = [
        Document(name: "Doc 1"),
        Document(name: "Doc 2"),
        Document(name: "Doc 3"),
        Document(name: "Doc 4"),
    ]

}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadsTableViewCellIdentifier", for: indexPath) as! DocumentTableViewCell
        
        cell.configure(with: documents[indexPath.row])
        
        return cell
    }
}
