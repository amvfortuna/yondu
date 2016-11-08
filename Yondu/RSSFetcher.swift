//
//  RSSFetcher.swift
//  Yondu
//
//  Created by Anna Fortuna on 07/11/2016.
//  Copyright © 2016 AVF. All rights reserved.
//

import FeedKit

class RSSFetcher {
    static var currentlyFetching = false

    class func beginFetch(completion: @escaping(_ rssFeed: [RSSFeedItem]) -> ()) {
        if !RSSFetcher.currentlyFetching {
            RSSFetcher.currentlyFetching = true
            var counter = 0
            var consolidatedFeeds = [RSSFeedItem]()
            
            // Begin fetching and parsing RSS Feed in the background
            DispatchQueue.global(qos: .userInitiated).async {
                for urlString in Config.sharedInstance.urls {
                    if let url = URL(string: urlString) {
                        FeedParser(URL: url)?.parse { (result) in
                            guard result.isSuccess, let feed = result.rssFeed, let items = feed.items else {
                                Config.sharedInstance.log("Error fetching feed: \(result.error)")
                                return
                            }
                            consolidatedFeeds.append(contentsOf: items)
                            counter += 1
                            if counter == Config.sharedInstance.urls.count {
                                DispatchQueue.main.async {
                                    // Perform updates in the main thread when finished
                                    RSSFetcher.currentlyFetching = false
                                    completion(consolidatedFeeds)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
