//
//  Repository.swift
//  PhotoPoints
//
//  Created by Stephen Gomez-Fox on 5/9/20.
//  Copyright © 2020 Cascadia College. All rights reserved.
//

import Foundation

class Repository {
    
    // Repository is a singleton, access using Repository.instance
    public static let instance = Repository()
    private init() {}
    

    // TODO:  REMOVE TEST CODE
    // Repository default test - always succeeds if repository instance exists
    func test() -> Bool {
        print("REPOSITORY DEFAULT TEST: SUCCESS")
        return true
    }
    
}
