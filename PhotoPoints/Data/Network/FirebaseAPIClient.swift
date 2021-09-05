//
//  FirebaseAPIClient.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Combine
import FirebaseFirestore
import FirebaseStorage

class FirebaseAPIClient: APIClient {
    
    let itemsCollection = Firestore.firestore().collection("items")
    let storageRef = Storage.storage().reference()
    
    let repository = Repository.instance
    
    func getItems() -> Future<[Item], Error> {
        Future { promise in
            self.itemsCollection.getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                if let documents = snapshot?.documents {
                    let items = documents.compactMap { object in
                        try? JSONDecoder().decode(Item.self, from: object.data())
                    }
                    
                    promise(.success(items))
                }
            }
        }
    }
    
    func getTodaysUserPhotos(for item: Item) {
        
    }
    
    func upload(_ submission: Submission) {
        
    }
    
    func uploadItems() {
        let items = Repository.instance.items
        
        items.forEach { item in
            itemsCollection.addDocument(data: item.dictionary)
        }
    }
    
    func getImageData(_ image: Image) -> Future<Data?, Never> {
        if let cachedImage = repository.imageCache[image.fullFilename] {
            return Future { $0(.success(cachedImage)) }
        }
        
        let reference = storageRef.child(image.fullFilename)
        let maxSize: Int64 = 2048 * 1024
        
        return Future { promise in
            reference.getData(maxSize: maxSize) { data, error in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    self.repository.imageCache[image.fullFilename] = data
                    
                    promise(.success(data))
                }
            }
        }
    }
}
