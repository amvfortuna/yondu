//
//  UIImageView+DownloadImage.swift
//  Yondu
//
//  Created by Anna Fortuna on 08/11/2016.
//  Copyright © 2016 AVF. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImage(_ urlString: String?) {
        if let notNilURL = urlString, let url = URL(string: notNilURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.image = UIImage(data: data)
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.image = UIImage(named: "default")
                    }
                }
            }
        } else {
            self.image = UIImage(named: "default")
        }
    }
}
