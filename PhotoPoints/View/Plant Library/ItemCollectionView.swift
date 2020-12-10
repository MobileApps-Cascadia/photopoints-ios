//
//  PlantsCollectionView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

private let cellIdentifier = "ItemCollectionCell"

class ItemCollectionView: UICollectionViewController {
    
    let repository = Repository.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
//        repository.loadInitData()
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor(named: "pp-background")
        collectionView.register(ItemCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func configureNavBar() {
        
        // modern nav bar appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        let emptyBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = emptyBackButton
        
        // for frosty appearance beneath the larger nav bar when scrolled to the top
        // can't see it in action right now as the image starts below the nav bar
        navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
    }
    
}

// MARK: - UICollectionViewDelegate/DataSource

// our class by default conforms to the UICollectionViewDelegate protocol
extension ItemCollectionView {
    
    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repository.getItems()!.count
    }
    
    // configure cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionCell
        let thisItem = repository.getItems()![indexPath.row]
        cell.configureFor(item: thisItem)
        return cell
    }
    
    // navigate to detail view when cell selected
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisItem = repository.getItems()![indexPath.row]
        navigationController?.pushViewController(ItemDetailView(item: thisItem), animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

// we need to adopt the flow layout protocol to obtain the classic scrollable grid appearance
extension ItemCollectionView: UICollectionViewDelegateFlowLayout {
    
    // header size (account for nav bar)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.safeAreaInsets.top)
    }
    
    // footer size (account for tab bar)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.safeAreaInsets.bottom)
    }
    
    // line spacing (vertical)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // interim spacing (horizontal)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //account for spacing
        let width = (view.frame.width - 1) / 2
        return CGSize(width: width, height: width)
    }
    
}
