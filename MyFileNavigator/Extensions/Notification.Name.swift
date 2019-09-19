//
//  Notification.swift
//  MyFileNavigator
//
//  Created by Vladislav Petrov on 17/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didFileUpload = Notification.Name("didFileUpload")
    static let didFileUploadAborted = Notification.Name("didFileUploadAborted")
}
