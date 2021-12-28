//
//  PackageCollectionViewCell.swift
//  weddingPackage
//
//  Created by NoON .. on 23/05/1443 AH.
//

import UIKit

class PostCell: UICollectionViewCell {
    @IBOutlet weak var imagePackage: UIImageView!
    @IBOutlet weak var namePackage: UILabel!
    @IBOutlet weak var pricePackage: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    func configure(with post:Post) -> UICollectionViewCell {
        namePackage.text = post.namePackage
        pricePackage.text = post.price
        userImageView.loadImageUsingCache(with: post.user.imageUrl)
        imagePackage.loadImageUsingCache(with: post.imageUrl)
        return self
    }
    override func prepareForReuse() {
        self.imagePackage.image = nil
        self.userImageView.image = nil

    }
}
