//
//  SongViewModel.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 4/28/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

struct SongViewModel {
    let title: String
    let duration: String
}

extension SongViewModel {
    
    init(song: Song) {
        self.title = song.censoredName
        
        //track in miliseconds
        let timeInSeconds = song.trackTime / 1000
        let minutes = timeInSeconds / 60 % 60
        let seconds = timeInSeconds % 60
        self.duration = "\(minutes): \(seconds)"
    }
}
