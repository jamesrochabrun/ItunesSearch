//
//  SongsListVC.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 4/28/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailVC: UITableViewController {
    
    var album: Album?
    lazy var dataSource: AlbumDetailDataSource = {
        return AlbumDetailDataSource(songs: self.album!.songs)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {
        tableView.register(SongCell.self)
        tableView.dataSource = dataSource
    }
}

//MARK: - Delegate methods tableview
extension AlbumDetailVC {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = AlbumCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        if let album = self.album {
            let viewModel = AlbumCellViewModel(album: album)
            headerCell.configure(with: viewModel)
        }
        return section == 0 ? headerCell : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 100 : 0
    }
}







