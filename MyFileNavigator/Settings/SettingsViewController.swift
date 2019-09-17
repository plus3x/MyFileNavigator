//
//  SettingsViewController.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 06/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBAction func onCleanAllDucomentsTap(_ sender: UIButton) {        
        DocumentSaver.cleanAll()
    }
}
