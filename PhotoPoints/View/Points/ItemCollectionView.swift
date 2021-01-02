//
//  PlantsCollectionView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionView: UICollectionViewController {
    
    // MARK: - Properties
    
    let repository = Repository.instance
    
    private let cellIdentifier = "ItemCollectionCell"

    private let headerIdentifier = "ItemHeaderView"
    
    private let footerIdentifier = "ItemFooterView"
    
    // MARK: - Setup
    
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor(named: "pp-background")
        collectionView.register(ItemCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ItemHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(ItemFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    func configureNavBar() {
        if let navBar = navigationController?.navigationBar {
            // modern nav bar appearance
            let emptyBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            navBar.prefersLargeTitles = true
            navBar.topItem?.backBarButtonItem = emptyBackButton
            navBar.topItem?.title = "North Creek Forest"
        }
    }
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reload data to update survey indicator circles
        navigationController?.navigationBar.sizeToFit()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate/DataSource

// our class by default conforms to the UICollectionViewDelegate protocol
extension ItemCollectionView {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ItemHeaderView
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! ItemFooterView
        }
        fatalError()
    }
    
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
        return CGSize(width: view.frame.width, height: 308)
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
        return 0
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //account for spacing
        let width = view.frame.width
        return CGSize(width: width, height: 80)
    }
    
}
