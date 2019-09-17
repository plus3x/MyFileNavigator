//
//  UploadViewController.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 27/08/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let preparedDocuments = [
        Document(
            name: "MovieMates Logo.svg",
            url: "https://moviemates.us/wp-content/uploads/2017/02/MM_Logo_mini.svg"
        ),
        Document(
            name: "MovieMates BG.jpg",
            url: "https://moviemates.us/wp-content/themes/moviemates/images/bg_hader.jpg"
        ),
        Document(
            name: "Wave file example.wav",
            url: "https://www.nch.com.au/acm/11k16bitpcm.wav"
        ),
        Document(
            name: "Mov file example.mov",
            url: "https://file-examples.com/wp-content/uploads/2018/04/file_example_MOV_1920_2_2MB.mov"
        ),
    ]
    var documents = [Document]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadDocuments()
        
        if let allDocuments = try? DocumentSaver.get(), allDocuments.count == 0 {
            preparedDocuments.forEach(DocumentSaver.save)
            reloadDocuments()
        }
        
        tableView.reloadData()
    }
    
    private func reloadDocuments() {
        if let documents = try? DocumentSaver.get() {
            self.documents = documents.filter([.downloadable, .downloading])
        }
    }
}

extension UploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UploadTableViewCell.identifier, for: indexPath) as! UploadTableViewCell
        
        let document = documents[indexPath.row]
        cell.configure(with: document)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let document = documents[indexPath.row]
        
        guard document.state == .downloadable else { return }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UploadTableViewCell.identifier, for: indexPath) as! UploadTableViewCell
        
        update(document, in: cell, with: .downloading)
        
        reloadDocuments()
        
        DispatchQueue(label: "\(document.name) downloading").async {
            let url = URL(string: document.url)!
            
            if let data = try? Data(contentsOf: url) {
                self.update(document, in: cell, with: .downloaded, and: nil, and: data)
                self.notify(with: "\(document.name) successfuly downloaded!")
            } else {
                self.update(document, in: cell, with: .downloadable)
                self.notify(with: "\(document.name) something went wrong!")
            }
            
            self.reloadDocuments()
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        
//        // Looks much more interested, can use middle state and progress bar, but no have success
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                self.update(document, in: cell, with: .downloadable, and: nil)
//                self.notify(with: "Uploading failed by reason: \"\(error)\"")
//            } else if let data = data {
//                self.update(document, in: cell, with: .downloaded, and: nil, and: data)
//                self.notify(with: "Uploading successfuls")
//            }
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//
//        URLSession.shared.getAllTasks { tasks in
//            _ = tasks.first { $0.taskIdentifier == task.taskIdentifier }
//        }
//
//        update(document, in: cell, with: .downloading, and: task.progress)
//
//        task.resume()
    }
    
    private func update(_ document: Document, in cell: UploadTableViewCell, with state: Document.State, and progress: Progress? = nil, and data: Data? = nil) {
        document.state = state
//        document.progress = progress
        document.data = data
        
        DispatchQueue.main.async {
            cell.configure(with: document)
        }
        
        DocumentSaver.save(document)
    }
    
    private func notify(with object: String) {
        NotificationCenter.default.post(name: .init("MyFileNavigator"), object: object)
    }
}
