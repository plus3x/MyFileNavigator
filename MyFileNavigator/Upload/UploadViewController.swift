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
        Document(
            name: "Fender Stratocaster.usdz",
            url: "https://developer.apple.com/augmented-reality/quick-look/models/stratocaster/fender_stratocaster.usdz"
        )
    ]
    var documents = [Document]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async {
            self.reloadDocuments()
            
            if let allDocuments = try? DocumentSaver.get(), allDocuments.count == 0 {
                self.preparedDocuments.forEach(DocumentSaver.save)
                self.reloadDocuments()
            }
            
            DispatchQueue.main.async {
                self.reloadTableViewWithAnimation()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        let ncd = NotificationCenter.default
        ncd.addObserver(self, selector: #selector(didFileUpload(_:)), name: .didFileUpload, object: nil)
        ncd.addObserver(self, selector: #selector(didFileUploadAborted(_:)), name: .didFileUploadAborted, object: nil)
    }
    
    @objc private func didFileUpload(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let document = userInfo["document"] as? Document,
              let index = documents.firstIndex(where: { $0.name == document.name }) else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc private func didFileUploadAborted(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let document = userInfo["document"] as? Document,
              let index = documents.firstIndex(where: { $0.name == document.name }) else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func reloadDocuments() {
        guard let documents = try? DocumentSaver.get() else { return }
        
        self.documents = documents.filter([.downloadable, .downloading])
        
        if Settings.uploadingType == .urlSessionDataTask {
            URLSession.shared.getAllTasks { tasks in
                self.documents.enumerated().forEach { index, document in
                    guard let task = tasks.first(where: { $0.taskIdentifier == document.taskIdentifier }) else { return }
                    
                    document.progress = task.progress
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    private func reloadTableViewWithAnimation() {
        tableView.reloadSections(NSMutableIndexSet(index: 0) as IndexSet, with: .automatic)
    }
}

extension UploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UploadTableViewCell.identifier, for: indexPath) as! UploadTableViewCell
        
        let document = documents[indexPath.row]
        cell.configure(with: document)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        uploadDocument(from: tableView, at: indexPath)
    }
    
    private func uploadDocument(from tableView: UITableView, at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        guard document.state == .downloadable else { return }
        
        let ncd = NotificationCenter.default
        let task = upload(document, success: { data in
            if self.update(document, with: .downloaded, and: nil, and: data) {
                ncd.post(name: .didFileUpload, object: nil, userInfo: ["document": document])
                self.reloadDocuments()
            } else {
                _ = self.update(document, with: .downloadable)
                ncd.post(name: .didFileUploadAborted, object: nil, userInfo: ["document": document])
            }
        }, failure: {
            _ = self.update(document, with: .downloadable)
            ncd.post(name: .didFileUploadAborted, object: nil, userInfo: ["document": document])
            self.reloadDocuments()
        })
        
        _ = update(document, with: .downloading, and: task)
        reloadDocuments()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func upload(_ document: Document, success: @escaping (Data) -> Void, failure: @escaping () -> Void) -> URLSessionDataTask? {
        let url = URL(string: document.url)!
        
        switch Settings.uploadingType {
        case .dataContentOf:
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: url) {
                    success(data)
                } else {
                    failure()
                }
            }
            
            return nil
        case .urlSessionDataTask:
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    success(data)
                } else {
                    failure()
                }
            }
            
            task.resume()
            
            return task
        }
    }
    
    private func update(_ document: Document, with state: Document.State, and task: URLSessionDataTask? = nil, and data: Data? = nil) -> Bool {
        document.state = state
        document.taskIdentifier = task?.taskIdentifier
        
        return DocumentSaver.save(document, with: data)
    }
}
