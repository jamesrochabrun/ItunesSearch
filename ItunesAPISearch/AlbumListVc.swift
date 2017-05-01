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
    let client = ItunesAPIClient()
    var artist: Artist? {
        didSet {
            self.title = artist?.name
            if let albums = artist?.albums {
                dataSource.update(with: albums)
                tableView.reloadData()
            }
        }
    }
    //MARK: HERE IS HOW INITIALIZE DATSOURCE!
    lazy var dataSource: AlbumListDataSource = {
        return AlbumListDataSource(albums: [], tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
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
        let selectedAlbum = dataSource.getAlbum(from: indexPath)
        client.lookUpAlbum(withID: selectedAlbum.id) { (album, error) in
            albumDetailVC.album = album
        }
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}













