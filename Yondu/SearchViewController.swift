//
//  SearchViewController.swift
//  Yondu
//
//  Created by Anna Fortuna on 07/11/2016.
//  Copyright © 2016 AVF. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchResults: [Book] = [] { didSet { self.tableView.reloadData() } }
    fileprivate var rssProcessor = RSSProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rssProcessor.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}

// MARK: - Table view data source & delegate

extension SearchViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count > 0 ? self.searchResults.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.searchResults.count > 0 {
            let book = self.searchResults[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResult", for: indexPath) as! SearchResultCell
            cell.bookTitle.text = book.title ?? "Unknown Title"
            cell.category.text = book.category ?? "Unknown Category"
            cell.publicationDate.text = book.publicationDateString ?? "Unknown Publication Date"
            cell.thumbnail.downloadImage(book.thumbnail)
            cell.ratings.downloadImage(book.ratings)
            return cell
        } else {
            if UIApplication.shared.isNetworkActivityIndicatorVisible {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Searching", for: indexPath)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoBooks", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchResults.count > 0 {
            return 120
        } else {
            return 44
        }
    }
}

// MARK: - Search results

extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        RSSFetcher.beginFetch { [weak self] (finished, rssFeed) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let strongSelf = self else { return }
            if finished {
                strongSelf.rssProcessor.rssFeed = rssFeed!
                if let keyword = searchBar.text, keyword != "" {
                    strongSelf.rssProcessor.keyword = keyword
                }
            }
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.rssProcessor.keyword = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.rssProcessor.keyword = nil
        if self.searchResults.count == 0 {
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
}

// MARK: - RSSProcessor delegate

extension SearchViewController: RSSProcessorDelegate {
    func searchResults(results: [Book]?, forKeyword keyword: String) {
        if let searchKeyword = self.rssProcessor.keyword, searchKeyword == keyword, let results = results {
            self.searchResults = results
        }
    }
}
