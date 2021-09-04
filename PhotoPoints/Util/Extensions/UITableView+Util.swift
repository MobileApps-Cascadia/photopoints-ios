//
//  UITableView+Util.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 9/3/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeue<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        
        return dequeueReusableCell(withIdentifier: className) as? T
    }
}
