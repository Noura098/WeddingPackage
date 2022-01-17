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
    
    @IBOutlet weak var namePGLabel: UILabel!{
        didSet {
            namePGLabel.text = "packageName".localized
        }
    }
    @IBOutlet weak var postNamePackageLabel: UILabel!
    
    
    @IBOutlet weak var priceLabel1: UILabel!{
        didSet {
           priceLabel1.text = "Price".localized
        }
    }
    @IBOutlet weak var postPriceLabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel1: UILabel!{
        didSet {
            descriptionLabel1.text = "Description".localized
        }
    }
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var viewDetails: UIView!{
        didSet{
            // code shado
            viewDetails.layer.masksToBounds = true
            viewDetails.layer.cornerRadius = 15
            viewDetails.layer.masksToBounds = false
            viewDetails.layer.shadowOffset = CGSize(width: 0, height: 0)
            viewDetails.layer.shadowColor = UIColor.black.cgColor
            viewDetails.layer.shadowOpacity = 0.5
            viewDetails.layer.cornerRadius = 5
        }
    }
    
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
