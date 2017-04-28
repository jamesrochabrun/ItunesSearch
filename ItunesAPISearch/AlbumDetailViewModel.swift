//
//  AlbumDetailViewModel.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 4/28/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

struct AlbumDetailViewModel {
    
    let title: String
    let releaseDate: String
    let genre: String
}

extension AlbumDetailViewModel {
    
    init(album: Album) {
        self.title = album.censoredName
        self.genre = album.primaryGenre.name
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMM dd, yyyy"
        self.releaseDate = dateFormatter.string(from: album.releaseDate)
    }
}
