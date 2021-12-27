//
//  PackageCollectionViewCell.swift
//  weddingPackage
//
//  Created by NoON .. on 23/05/1443 AH.
//

import UIKit

class PackageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imagePackage: UIImageView!
    @IBOutlet weak var namePackage: UILabel!
    @IBOutlet weak var pricePackage: UILabel!

    func configure(with post:Post) -> UICollectionViewCell {
        namePackage.text = post.namePackage
        pricePackage.text = post.description
        imagePackage.loadImageUsingCache(with: post.imageUrl)
        return self
    }
    override func prepareForReuse() {
        imagePackage.image = nil
    }
}
