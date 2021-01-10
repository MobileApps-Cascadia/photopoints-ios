//
//  PointsTable.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class PointsTable: UITableViewController {
    
    let repository = Repository.instance
    
    let pointsIdentifier = "Points Identifier"
    let progressIdentifier = "Progress Identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .systemBlue
        configureTableView()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reload data to update survey indicator circles
        navigationController?.navigationBar.sizeToFit()
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.backgroundColor = UIColor(named: "pp-background-color")
//        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(PointsCell.self, forCellReuseIdentifier: pointsIdentifier)
        tableView.register(ProgressCell.self, forCellReuseIdentifier: progressIdentifier)
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
}

extension PointsTable {
    
    // cell setup
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let progressCell = tableView.dequeueReusableCell(withIdentifier: progressIdentifier) as! ProgressCell
            progressCell.setupSubviews()
            progressCell.updateProgress()
            return progressCell
        }
        
        let thisItem = repository.getItems()![indexPath.row]
        let pointsCell = tableView.dequeueReusableCell(withIdentifier: pointsIdentifier) as! PointsCell
        pointsCell.setupSubviews()
        pointsCell.configure(for: thisItem)
        return pointsCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : repository.getItems()?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Progress" : "PhotoPoints"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = section == 0 ? "Progress" : "PhotoPoints"
        let header = SectionHeader()
        header.setupSubviews()
        header.setTitle(title: title)
        return header
    }
}
