//
//  PointsTableViewController.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Combine
import UIKit

protocol DateViewDelegate {
    func fadeInDate()
}

class PointsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            viewModel.shouldReloadTable
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.tableView.reloadData()
                }
                .store(in: &subscribers)
        }
    }
    
    let repository = Repository.instance
    
    let viewModel = PointsTableViewModel(apiClient: FirebaseAPIClient())
    
    var subscribers = Set<AnyCancellable>()
    
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
        viewModel.fetchItems()
    }
    
    func configureTableView() {
        tableView.tableHeaderView = dateView
        tableView.sectionFooterHeight = 0
        
        tableView.register(ProgressTableCell.self)
        tableView.register(PointTableCell.self)
        tableView.register(FooterTableCell.self)
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
extension PointsTableViewController {
    
    // on it's own the date doesn't fade fast enough when scrolling
    // this makes the date fade proportionally to a defined scroll distance
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topInset = view.safeAreaInsets.top
        let dateFadeDistance: CGFloat = 10
        let difference = topInset + scrollView.contentOffset.y
        
        if dateView.alpha != 0 && difference < dateFadeDistance {
            dateView.dateLabel.alpha = 1 - difference / dateFadeDistance
        } else {
            dateView.dateLabel.alpha = 0
        }
    }
    
}

// MARK: - TableViewDataSource
extension PointsTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return viewModel.items.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let progressCell = tableView.dequeue(ProgressTableCell.self)
            progressCell?.updateProgress()
            return progressCell ?? UITableViewCell()
        case 1:
            let thisItem = viewModel.items[indexPath.row]
            let pointCell = tableView.dequeue(PointTableCell.self)
            pointCell?.configure(for: thisItem)
            return pointCell ?? UITableViewCell()
        default:
            return tableView.dequeue(FooterTableCell.self) ?? UITableViewCell()
        }
    }

}

// MARK: - UITableViewDelegate
extension PointsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let thisItem = viewModel.items[indexPath.row]
            let detail = PointsDetailViewController(item: thisItem)
            detail.dateViewDelegate = self
            dateView.fadeOutDate()
            navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return SectionHeader(title: "Today's Progress")
        case 1:
            return SectionHeader(title: "PhotoPoints")
        default:
            return SectionHeader(title: "About")
        }
    }

}

extension PointsTableViewController: DateViewDelegate {
    
    func fadeInDate() {
        dateView.fadeInDate()
    }
    
}
