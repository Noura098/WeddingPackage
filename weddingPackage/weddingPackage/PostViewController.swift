//
//  PostViewController.swift
//  weddingPackage
//
//  Created by NoON .. on 23/05/1443 AH.
//

import UIKit
import Firebase
class PostViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postPackageNameTF: UITextField!
    @IBOutlet weak var postPriceTF: UITextField!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    let activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func addActionButton(_ sender: Any) {
    }
}
