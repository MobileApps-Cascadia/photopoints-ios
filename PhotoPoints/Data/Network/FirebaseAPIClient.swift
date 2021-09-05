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
                    let items = documents.compactMap { ItemMapper.map(dictionary: $0.data()) }
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
        let items = Repository.instance.getItems()
        
        items.forEach { item in
            if let data = ItemMapper.dictionary(for: item) {
                itemsCollection.addDocument(data: data)
            }
        }
    }
    
    func getImageData(_ image: Image) -> Future<Data?, Never> {
        let filename = image.filename ?? ""
        let fileFormat = image.fileformat ?? ""
        let fullFilename = "\(filename).\(fileFormat)"
        let reference = storageRef.child(fullFilename)
        let maxSize: Int64 = 2048 * 1024
        
        if let cachedImage = repository.imageCache[fullFilename] {
            return Future { $0(.success(cachedImage)) }
        }
        
        return Future { promise in
            reference.getData(maxSize: maxSize) { data, error in
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    self.repository.imageCache[fullFilename] = data
                    
                    promise(.success(data))
                }
            }
        }
    }
}
