//
//  BaseCell.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 1/9/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    // main background of each cell
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor(named: "pp-background")
    }
    
    func setupSubviews() {
        contentView.addSubview(mainView)
        mainView.pin(to: contentView, horizPadding: 2, vertPadding: .globalPadding)
    }
    
}
