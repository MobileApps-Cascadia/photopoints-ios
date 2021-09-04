//
//  FirebaseAPIClient.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Combine
import FirebaseFirestore

class FirebaseAPIClient: APIClient {
    
    let itemsCollection = Firestore.firestore().collection("items")
    
    func getItems() -> Future<[Item], Error> {
        Future { promise in
            self.itemsCollection.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                print(snapshot?.documents ?? "no snapshot")
            }
        }
    }
    
    func upload(items: [Item]) {
        print(items.count)
        
        items.forEach { item in
            if let dictionary = ItemMapper.dictionary(for: item) {
                self.itemsCollection.addDocument(data: dictionary)
            }
        }
    }
    
    func getAllUserPhotos(for item: Item) {
        
    }
    
    func getTodaysUserPhotos(for item: Item) {
        
    }
    
    func upload(_ submission: Submission) {
        
    }
    
}
