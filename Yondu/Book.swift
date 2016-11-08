//
//  Book.swift
//  Yondu
//
//  Created by Anna Fortuna on 07/11/2016.
//  Copyright © 2016 AVF. All rights reserved.
//

import UIKit

class Book: NSObject {
    /*
     We can use this instead if we want to chop of the order number from its title
     
    var title: String? {
        didSet {
            // Since the order number is always followed by a space, we'll look
            // for the location of that space and retrieve the rest of the title.
            if let firstSpaceCharacter = title?.range(of: " ") {
                self.title = title?.substring(from: firstSpaceCharacter.upperBound)
            }
        }
    }
    */
    var title: String?
    var publicationDate: Date?
    var publicationDateString: String? {
        get {
            if publicationDate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d, yyyy"
                return dateFormatter.string(from: publicationDate!)
            }
            return nil
        }
    }
    var ratings: String?
    var thumbnail: String?
    var category: String?
    override var description: String {
        return title ?? "<Book>: Unknown book"
    }
}
