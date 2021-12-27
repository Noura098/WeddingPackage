//
//  HomeViewController.swift
//  weddingPackage
//
//  Created by NoON .. on 17/05/1443 AH.
//

import UIKit
import Firebase
import SwiftUI
class HomeViewController: UIViewController {
    var posts = [Post]()
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    @IBOutlet weak var packagesCollectionView: UICollectionView!{
        didSet {
            packagesCollectionView.delegate = self
            packagesCollectionView.dataSource = self
            packagesCollectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } catch  {
            print("ERROR in signout",error.localizedDescription)
        }
    }
    }
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PackageCollectionViewCell
        return cell.configure(with: posts[indexPath.row])
    }
}
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, sizeForItemAT indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.493, height: self.view.frame.width * 0.45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, insetForSrctionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PackageCollectionViewCell
        selectedPostImage = cell.imagePackage.image
        selectedPost = posts[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == posts[indexPath.row].user.id{
          performSegue(withIdentifier: "toPostVC", sender: self)
        }else {
            performSegue(withIdentifier: "toDetailsVC", sender: self)
            
        }
    }
}

