//
//  DateHeaderStyle.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 3/12/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

extension Date {
    func headerStyle() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        let dayString = String(formatter.string(from: Date()).uppercased().dropLast(6))
        return dayString
    }
}
