//
//  RSSProcessor.swift
//  Yondu
//
//  Created by Anna Fortuna on 08/11/2016.
//  Copyright © 2016 AVF. All rights reserved.
//

import FeedKit
import Kanna

protocol RSSProcessorDelegate: class {
    func searchResults(results: [Book]?, forKeyword keyword: String)
}

class RSSProcessor: NSObject {
    var rssFeed: [RSSFeedItem]?
    var fourStarBooks: [Book]?
    var filteredFeed = [Book]()
    var keyword: String? {
        didSet {
            if keyword != nil {
                self.searchKeyword(self.keyword!)
            }
        }
    }
    weak var delegate: RSSProcessorDelegate?

    fileprivate func searchKeyword(_ keyword: String) {
        if self.rssFeed != nil {
            self.filteredFeed.removeAll()
        
            DispatchQueue.global(qos: .userInitiated).async {
                // Iterate each RSS Feed to and check for a match in keyword
                for item in self.rssFeed! {
                    autoreleasepool {
                        if item.title?.lowercased().range(of: keyword.lowercased()) != nil {
                            self.proccessFeedItem(item)
                        }
                    }
                }
                
                /* 
                 Here we check if we found books with at least 4.5 stars
                 If no books were found, we check if there are books that have 4 stars then
                 we'll display them.
                */
                if self.filteredFeed.count == 0 && self.fourStarBooks != nil {
                    self.filteredFeed = self.fourStarBooks!
                }
                self.fourStarBooks = nil
                
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.delegate?.searchResults(results: strongSelf.filteredFeed, forKeyword: keyword)
                }
            }
        }
    }
    
    fileprivate func proccessFeedItem(_ item: RSSFeedItem) {
        if let html = HTML(html: item.description!, encoding: .utf8) {
            /*
             Since we want to display books that have 4.5+ stars only, it's important
             that we check the ratings before we process the whole item.
             
             If this book has at least 4.5 stars, we process it and add it directly 
             to the filterFeed array. Else, we'll check if it has at least 4 stars, if it does
             we'll add it to the fourStarBooks array. If not, we'll disregard this and move on.
            */
            if let ratingsImg = (html.at_xpath("//img[contains(@src,'.gif')]"))?["src"] {
                if ratingsImg.range(of: "stars-4-5") != nil || ratingsImg.range(of: "stars-5-0") != nil {
                    let bookCoverImg = (html.at_xpath("//img[1]"))?["src"]
                    let category = html.at_xpath("//a[contains(text(), 'Bestsellers in')]")
                    let book = self.createBook(item.title, item.pubDate, bookCoverImg, ratingsImg, category?.content)
                    self.filteredFeed.append(book)
                } else if ratingsImg.range(of: "stars-4-0") != nil && self.filteredFeed.count == 0 {
                    if self.fourStarBooks == nil {
                        self.fourStarBooks = [Book]()
                    }
                    let bookCoverImg = (html.at_xpath("//img[1]"))?["src"]
                    let category = html.at_xpath("//a[contains(text(), 'Bestsellers in')]")
                    let book = self.createBook(item.title, item.pubDate, bookCoverImg, ratingsImg, category?.content)
                    self.fourStarBooks?.append(book)
                }
            }
        }
    }
    
    fileprivate func createBook(_ title: String?, _ publicationDate: Date?, _ bookCover: String?, _ ratings: String?, _ category: String?) -> Book {
        
        let book = Book()
        book.title = title?.trimmingCharacters(in: .whitespacesAndNewlines)
        book.publicationDate = publicationDate
        book.thumbnail = bookCover
        book.ratings = ratings
        book.category = category
        return book
    }
}
