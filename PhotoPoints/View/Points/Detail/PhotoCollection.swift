//
//  PhotoCollection.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/16/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PhotoCollection: UICollectionViewController {
    
    let repository = Repository.instance
    
    let photoIdentifier = "Photo Identifier"
    
    var photos: [UserPhoto]!
    
    var item: Item!
    
    convenience init(item: Item) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.item = item
        self.photos = repository.getTodaysUserPhotos(for: item)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: photoIdentifier)
        collectionView.backgroundColor = .gray
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoIdentifier, for: indexPath) as! PhotoCell
        photoCell.setPhoto(photo: photos[indexPath.row])
        return photoCell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

}
