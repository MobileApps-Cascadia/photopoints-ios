//
//  APIClient.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Combine
import Foundation

protocol APIClient {
    func getItems() -> Future<[Item], Error>
    func getTodaysUserPhotos(for item: Item)
    func upload(_ submission: Submission)
}
