//
//  Settings.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 17/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import Foundation

class Settings {
    enum UploadingType: String, CaseIterable {
        case dataContentOf = "DataContentOf"
        case urlSessionDataTask = "URLSessionDataTask"
    }
    
    static let uploadingTypeStoringKey = "Settings.UploadingType"
    static let uploadingTypeDefaultValue: UploadingType = .dataContentOf
    static var uploadingType: UploadingType {
        get {
            let uploadingTypeStringKey = UserDefaults.standard.string(forKey: uploadingTypeStoringKey)
            
            if let uploadingType = UploadingType.allCases.first(where: { $0.rawValue == uploadingTypeStringKey }) {
                return uploadingType
            } else {
                return uploadingTypeDefaultValue
            }
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: uploadingTypeStoringKey)
            UserDefaults.standard.synchronize()
        }
    }
}
