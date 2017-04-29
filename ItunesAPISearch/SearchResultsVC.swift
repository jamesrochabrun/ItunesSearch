//
//  SearchResultsController.swift
//  ItunesAPISearch
//
//  Created by James Rochabrun on 4/28/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsVC: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = SearchResultsDataSource()
    let client = ItunesAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SearchResultsVC.dismissVC))
        setUpViews()
    }
    
    private func setUpViews() {
        tableView.register(UITableViewCell.self)
        tableView.dataSource = dataSource
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        //this hides the searchbar in the next vc
        definesPresentationContext = true
    }
    
    func dismissVC() {
        self.dismiss(animated: true)
    }
}

//MARK: Search updates protocol "delegate" gets triggered every time 
extension SearchResultsVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
//        dataSource.update(with: [Stub.artist])
        client.searchForArtists(withTerm: searchController.searchBar.text!) { [weak self] (artists, error) in
            self?.dataSource.update(with: artists)
            self?.tableView.reloadData()
        }
    }
}

//MARK: Delegate tableview methods
extension SearchResultsVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let albumListVC = AlbumListVC()
        let artist = dataSource.getArtist(from: indexPath)
        client.lookUpArtist(withID: artist.id) { (artist, error) in
            albumListVC.artist = artist
        }
        self.navigationController?.pushViewController(albumListVC, animated: true)
    }
}









