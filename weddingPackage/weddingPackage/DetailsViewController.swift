//
//  DetailsViewController.swift
//  weddingPackage
//
//  Created by NoON .. on 23/05/1443 AH.
//

import UIKit

class DetailsViewController: UIViewController {
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postNamePackageLabel: UILabel!
    @IBOutlet weak var postPriceLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage{
            postNamePackageLabel.text = selectedPost.namePackage
            postDescriptionLabel.text = selectedPost.description
            postPriceLabel.text = selectedPost.price
            postImageView.image = selectedImage
        }
 
    }
}
