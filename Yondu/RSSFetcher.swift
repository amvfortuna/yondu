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
    static let session = URLSession(configuration: .default)
    
    class func beginFetch(completion: @escaping(_ finished: Bool, _ rssFeed: [RSSFeedItem]?) -> ()) {
        if !RSSFetcher.currentlyFetching {
            RSSFetcher.currentlyFetching = true
            var counter = 0
            var consolidatedFeeds = [RSSFeedItem]()
            
            for urlString in Config.sharedInstance.urls {
                let urlRequest = URLRequest(url: URL(string: urlString)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
                session.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
                    guard let data = data, error == nil else {
                        Config.sharedInstance.log("Unable to retrieve XML: \(error?.localizedDescription)")
                        RSSFetcher.currentlyFetching = false
                        completion(false, nil)
                        return
                    }
                    
                    FeedParser(data: data).parse { (result) in
                        guard result.isSuccess, let feed = result.rssFeed, let items = feed.items else {
                            Config.sharedInstance.log("Error parsing feed: \(result.error)")
                            RSSFetcher.currentlyFetching = false
                            completion(false, nil)
                            return
                        }
                        consolidatedFeeds.append(contentsOf: items)
                        counter += 1
                        if counter == Config.sharedInstance.urls.count {
                            DispatchQueue.main.async {
                                // Perform updates in the main thread when finished
                                RSSFetcher.currentlyFetching = false
                                completion(true, consolidatedFeeds)
                            }
                        }
                    }
                }).resume()
            }
        }
    }
}
