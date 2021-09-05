//
//  PointsTableViewModel.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Combine
import Foundation

class PointsTableViewModel {
    
    var items = [Item]()
    
    let shouldReloadTable = PassthroughSubject<Bool, Never>()
    
    private var itemsCancellable: AnyCancellable?
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchItems() {
        itemsCancellable = apiClient.getItems()
            .replaceError(with: [])
            .sink { [weak self] items in
                self?.items = items
                self?.shouldReloadTable.send(true)
            }
    }
}
