//
//  PlantsCollectionView.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 4/24/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation
import UIKit

private let cellIdentifier = "PlantsCollectionCell"

class PlantsCollectionView: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor(named: "pp-background")
        collectionView.register(PlantsCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
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
extension PlantsCollectionView {
    
    // number of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MockDatabase.plants.count
    }
    
    // configure cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PlantsCollectionCell
        let thisPlant = MockDatabase.plants[indexPath.row]
        cell.configureFor(plantItem: thisPlant)
        return cell
    }
    
    // navigate to detail view when cell selected
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisPlant = MockDatabase.plants[indexPath.row]
        navigationController?.pushViewController(PlantDetailView(plantItem: thisPlant), animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

// we need to adopt the flow layout protocol to obtain the classic scrollable grid appearance
extension PlantsCollectionView: UICollectionViewDelegateFlowLayout {
    
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
