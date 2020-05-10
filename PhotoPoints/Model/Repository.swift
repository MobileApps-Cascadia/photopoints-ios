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
    
    // create a queue for operations requiring thread safety
    private let serialQueue = DispatchQueue(label: "repoQueue")

    
    
    
    // TESTS
    
    
    // TODO:  REMOVE TEST CODE
    // Repository Thread Safe Test - An example of thread safe repository operation
    // returns true if serialQueue sync operation completes
    func testSync() -> Bool {
        let results: String = "REPOSITORY THREAD SAFE TEST: "
        var success = false
        serialQueue.sync {
            success = true
        }
        print(results + (success ? "SUCCESS" : "FAIL"))
        return success
    }
    

    // TODO:  REMOVE TEST CODE
    // Repository default test - always succeeds if repository instance exists
    func test() -> Bool {
        print("REPOSITORY DEFAULT TEST: SUCCESS")
        return true
    }
}
