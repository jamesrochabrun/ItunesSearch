//
//  ArtworkDownloader.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 5/1/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//Each download will create a new instance of this class
class ArtworkDownloader: Operation {
    
    let album: Album
    
    init(album: Album) {
        self.album = album
        super.init()
    }
    
    override func main() {
        //if the operation waa canceleed because the cell was out of screen :not implemented
        if self.isCancelled {
            return
        }
        //url checking
        guard let url = URL(string: album.artWorkURL) else {
            return
        }
        do {
            let imageData = try Data(contentsOf: url)
            if self.isCancelled {
                return //if user scroll again need to check if developer canceled operation
            }
            //checking the byte count of the instance
            if imageData.count > 0 {
                album.artwork = UIImage(data: imageData)
                album.artworkState = .downloaded
            } else {
                album.artworkState = .failed
            }
        } catch let error {
            print("Operation Error: -> , \(error)")
            self.cancel()
        }
    }
}





