//
//  PointsTable.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

protocol DateViewDelegate {
    func fadeInDate()
}

class PointsTable: UITableViewController {
    
    let repository = Repository.instance
    
    let progressIdentifier = "Progress Identifier"
    let pointIdentifier = "Point Identifier"
    let footerIdentifier = "Footer Identifier"
    
    lazy var topInset = view.safeAreaInsets.top
    let dateFadeDistance: CGFloat = 10
    var difference: CGFloat = 0
    
    lazy var dateView: DateView = {
        let navBarHeight = self.navigationController!.navigationBar.frame.height
        let paddingTop = -(navBarHeight + .globalPadding)
        return DateView(paddingTop: paddingTop)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reload data to update survey indicator circles
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.tableHeaderView = dateView
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(ProgressCell.self, forCellReuseIdentifier: progressIdentifier)
        tableView.register(PointCell.self, forCellReuseIdentifier: pointIdentifier)
        tableView.register(FooterCell.self, forCellReuseIdentifier: footerIdentifier)
    }
    
    func configureNavBar() {
        let navBar = navigationController!.navigationBar
        let emptyBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navBar.prefersLargeTitles = true
        navBar.topItem?.backBarButtonItem = emptyBackButton
        navBar.topItem?.title = "North Creek Forest"
        navBar.sizeToFit()
    }
}

// MARK: - ScrollViewDelegate
extension PointsTable {
    
    // on it's own the date doesn't fade fast enough when scrolling
    // this makes the date fade proportionally to a defined scroll distance
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        difference = topInset + scrollView.contentOffset.y
        if dateView.alpha != 0 && difference < dateFadeDistance {
            dateView.dateLabel.alpha = 1 - difference / dateFadeDistance
        } else {
            dateView.dateLabel.alpha = 0
        }
    }
    
}

// MARK: - TableViewDataSource
extension PointsTable {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let progressCell = tableView.dequeueReusableCell(withIdentifier: progressIdentifier) as! ProgressCell
            progressCell.updateProgress()
            return progressCell
        case 1:
            let thisItem = repository.getItems()![indexPath.row]
            let pointCell = tableView.dequeueReusableCell(withIdentifier: pointIdentifier) as! PointCell
            pointCell.configure(for: thisItem)
            return pointCell
        default:
            return tableView.dequeueReusableCell(withIdentifier: footerIdentifier) as! FooterCell
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return repository.getItems()!.count
        default:
            return 1
        }
    }

}

// MARK: - UITableViewDelegate
extension PointsTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let thisItem = repository.getItems()![indexPath.row]
            let detail = PointsDetail(item: thisItem)
            detail.dateViewDelegate = self
            dateView.fadeOutDate()
            navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return SectionHeader(title: "Today's Progress")
        case 1:
            return SectionHeader(title: "PhotoPoints")
        default:
            return SectionHeader(title: "About")
        }
    }
    
    // these two methods are necessary to get rid of unwanted white space below section headers
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}

extension PointsTable: DateViewDelegate {
    
    func fadeInDate() {
        dateView.fadeInDate()
    }
    
}
