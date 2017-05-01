//
//  PendingOperations.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 5/1/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

class PendingOperations {
    
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()//adding the operations here
}
