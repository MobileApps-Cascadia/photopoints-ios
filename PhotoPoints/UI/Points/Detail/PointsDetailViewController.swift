//
//  PointsDetailViewController.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//
import UIKit

class PointsDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let repository = Repository.instance
    
    var thisItem: Item
    
    var scanDelegate: ScanDelegate!
    
    var dateViewDelegate: DateViewDelegate!
    
    lazy var allDetails = thisItem.details
    
    lazy var photoCollectionView = PhotoCollectionViewController(item: thisItem)
    
    // all of the text underneath the image
    lazy var shownDetails: [Detail] = {
        let excludedDetails: [String?] = ["common_names", "story", "short_description", "full_description"]
        
        return thisItem.details.filter { !excludedDetails.contains($0.property) }
    }()
    
    lazy var story: Detail? = {
        return allDetails.first { $0.property == "story" }
    }()
    
    // MARK: - Init
    
    init(item: Item) {
        self.thisItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = thisItem.label
        addChild(photoCollectionView)
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        // change to small tile on detail view
        navigationItem.largeTitleDisplayMode = .never
        
        photoCollectionView.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // change back to large title on parent view
        navigationItem.largeTitleDisplayMode = .always
        
        // using alertDelegate for scanner preview of this view but not in the library
        scanDelegate?.enableScanning()

        dateViewDelegate?.fadeInDate()
    }
    
    func setupTableView() {
        tableView.register(DetailPhotoTableCell.self)
        tableView.register(DetailTableCell.self)
        tableView.register(PhotoCollectionTableCell.self)
        tableView.register(PhotoCollectionPlaceholderCell.self)
        
        tableView.sectionFooterHeight = 0
    }
}

extension PointsDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return shownDetails.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch indexPath.section {
        case 0:
            let mainPhotoCell = tableView.dequeue(DetailPhotoTableCell.self)
            mainPhotoCell?.configure(for: thisItem)
            cell = mainPhotoCell
        case 1:
            if repository.didSubmitToday(for: thisItem) {
                let photoCollectionCell = tableView.dequeue(PhotoCollectionTableCell.self)
                photoCollectionCell?.addCollection(photoCollectionView)
                cell = photoCollectionCell
            } else {
                cell = tableView.dequeue(PhotoCollectionPlaceholderCell.self)
            }
        case 2:
            let detailCell = tableView.dequeue(DetailTableCell.self)
            detailCell?.configure(for: shownDetails[indexPath.row])
            cell = detailCell
        case 3:
            let detailCell = tableView.dequeue(DetailTableCell.self)
            detailCell?.configure(for: story)
            cell = detailCell
        default:
            cell = UITableViewCell()
        }
        
        return cell ?? UITableViewCell()
    }
}

extension PointsDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return SectionHeader(title: "Your Photos")
        case 2:
            return SectionHeader(title: "Details")
        case 3:
            return SectionHeader(title: "About")
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2, 3:
            return UITableView.automaticDimension
        default:
            return .globalPadding
        }
    }
    
}
