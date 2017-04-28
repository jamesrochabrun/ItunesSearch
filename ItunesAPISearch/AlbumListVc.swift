//
//  AlbumListVc.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 4/28/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class AlbumListVC: UITableViewController {
    
    fileprivate struct Constants {
        static let AlbumCellHeight: CGFloat = 80
    }
    
    var artist: Artist!
    lazy var dataSource: AlbumListDataSource = {
        return AlbumListDataSource(albums: self.artist.albums)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        self.title = artist.name
    }
    
    private func setUpViews() {
        tableView.register(AlbumCell.self)
        tableView.dataSource = dataSource
    }    
}

//MARK: - Delegate methods
extension AlbumListVC {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.AlbumCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let albumDetailVC = AlbumDetailVC(style: .grouped)
        let album = dataSource.getAlbum(from: indexPath)
        album.songs = Stub.songs
        albumDetailVC.album = album
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}













