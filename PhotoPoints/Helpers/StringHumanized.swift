//
//  StringHumanized.swift
//  PhotoPoints
//
//  Created by Clay Suttner on 2/4/21.
//  Copyright © 2021 Cascadia College. All rights reserved.
//

import Foundation

extension String {
    
    func humanized() -> String {
        return self.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
}
