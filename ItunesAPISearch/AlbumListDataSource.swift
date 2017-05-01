//
//  AlbumListDataSource.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 4/28/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class AlbumListDataSource: NSObject, UITableViewDataSource {

    fileprivate var albums: [Album]
    let tableView: UITableView
    
    init(albums: [Album], tableView: UITableView) {
        self.albums = albums
        self.tableView = tableView
        super.init()
    }
    let pendingOperations = PendingOperations()
    
    //MARK: DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AlbumCell
        let album = getAlbum(from: indexPath)
        let viewModel = AlbumCellViewModel(album: album)
        cell.configure(with: viewModel)
        cell.accessoryType = .disclosureIndicator
        //only perform request if state is placeholder
        if album.artworkState == .placeholder {
            downloadArtworkForAlbum(album, atIndexPath: indexPath)
        }
        return cell
    }
}

//MARK: - Helper methods
extension AlbumListDataSource {
    
    func getAlbum(from indexPath: IndexPath) -> Album {
        return albums[indexPath.row]
    }
    
    func update(with albums: [Album]) {
        self.albums = albums
    }
    
    //keep track of operation and download artwork
    func downloadArtworkForAlbum(_ album: Album, atIndexPath indexPath: IndexPath) {
        
        //1 checking if we already create an operation for the indexpath
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        //2 operation does not exist lets create one
        let downloader = ArtworkDownloader(album: album)
//        downloader.name = album.name
//        print(downloader.name)
        
        //3 when operation is complete...
        //operatio has a setter property called completionBlock that gets triggered after operation is completed
        downloader.completionBlock = {
            //check if operation is cancelled first if user scrolls
            if downloader.isCancelled {
                return
            }
            //now, because we are tracking for active operations and this one is completed we remove it from the pending dictionary
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                //then reload the road
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        //4 keep track of the operation added to the queue 
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    
    
    
    
}











