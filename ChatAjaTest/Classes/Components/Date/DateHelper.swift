//
//  DateHelper.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 12/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import Foundation

class DateHelper {
    class func stringFromDate(_ date: Date?) -> String {
        if let formatDate = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
            return formatter.string(from: formatDate)
        }
        return ""
    }
}
