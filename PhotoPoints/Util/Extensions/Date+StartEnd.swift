//
//  Date+StartEnd.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

extension Date {
    static let start = Calendar.current.startOfDay(for: Date())
    static let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
}
