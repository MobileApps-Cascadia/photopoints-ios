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
    
    let rootCollection = Firestore.firestore().collection("northCreekForest")
    
    func getItems() -> Future<[Item], Error> {
        Future { promise in
            self.rootCollection.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                print(snapshot?.documents)
            }
        }
    }
    
    func upload(items: [Item]) {
//        items.forEach { item in
//            self.rootCollection.addDocument(data: )
//        }
    }
    
    func getAllUserPhotos(for item: Item) {
        
    }
    
    func getTodaysUserPhotos(for item: Item) {
        
    }
    
    func upload(_ submission: Submission) {
        
    }
    
}
