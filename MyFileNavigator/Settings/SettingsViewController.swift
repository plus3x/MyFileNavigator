//
//  SettingsViewController.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 06/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var uploadingTypePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let row = Settings.UploadingType.allCases.firstIndex(where: { $0 == Settings.uploadingType }) {
            uploadingTypePickerView.selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func onCleanAllDucomentsTap(_ sender: UIButton) {
        DocumentSaver.cleanAll()
    }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Settings.UploadingType.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Settings.UploadingType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let title = Settings.UploadingType.allCases[row].rawValue
        
        label.text = title
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Settings.uploadingType = Settings.UploadingType.allCases[row]
    }
}
