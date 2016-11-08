//
//  SearchResultCell.swift
//  Yondu
//
//  Created by Anna Fortuna on 07/11/2016.
//  Copyright © 2016 AVF. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var publicationDate: UILabel!
    @IBOutlet weak var ratings: UIImageView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var category: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.category.text = nil
        self.bookTitle.text = nil
        self.publicationDate.text = nil
    }
}
