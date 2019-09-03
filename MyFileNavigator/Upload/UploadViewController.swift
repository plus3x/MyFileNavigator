//
//  UploadViewController.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {

    var uploads = [
        Upload(name: "Upload Doc1", link: "SomeLink"),
        Upload(name: "Upload Doc2", link: "SomeLink"),
        Upload(name: "Upload Doc3", link: "SomeLink"),
        Upload(name: "Upload Doc4", link: "SomeLink"),
        Upload(name: "Upload Doc5", link: "SomeLink"),
    ]

}

extension UploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadTableViewCellIdentifier", for: indexPath) as! UploadTableViewCell
        
        cell.configure(with: uploads[indexPath.row])
        
        return cell
    }
    
    
}
