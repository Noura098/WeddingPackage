//
//  HomeViewController.swift
//  weddingPackage
//
//  Created by NoON .. on 17/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {
    var posts = [Post]()
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    
    let imageNames = ["nn", "de", "1"]
      var index = 0
      var  timer: Timer!
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var packagesCollectionView: UICollectionView!{
        didSet {
            packagesCollectionView.delegate = self
            packagesCollectionView.dataSource = self
            packagesCollectionView.backgroundColor = .systemFill
        }
    }
    @IBOutlet weak var logoutBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    imageHeader.image = UIImage(named: "nn")
        
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector:
          #selector(self.loop), userInfo: nil, repeats: true)
    }
    
    @objc
      func loop() {
         if index != imageNames.count - 1 {
             index += 1
             changeImage(index: index)
         }else {
            index = 0
            changeImage(index: index)
         }
      }
    func changeImage(index: Int) {
        UIView.transition(with: self.imageHeader,
               duration: 2.0, //animation will take 2 seconds
               options: .transitionCrossDissolve,
               animations: {
            self.imageHeader.image = UIImage(named:
                   self.imageNames[index])
               }, completion: nil)
       }

    
    func getPosts() {
        let ref = Firestore.firestore()
        ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }
            if let snapshot = snapshot {
                print("POST CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let postData = diff.document.data()
                    switch diff.type {
                    case .added :
                        
                        if let userId = postData["userId"] as? String {
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("ERROR user Data",error.localizedDescription)
                                }
                                if let userSnapshot = userSnapshot,
                                   let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                                    let post = Post(dict:postData,id:diff.document.documentID,user:user)
                                
                                    if snapshot.documentChanges.count != 1 {
                                        self.posts.append(post)
                                        self.packagesCollectionView.insertItems(at: [IndexPath(item: self.posts.count - 1, section: 0)])
                                  }else {
                                      self.posts.insert(post,at:0)
                                      self.packagesCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                                        }
//                                    self.packagesCollectionView.reloadData()
                            }
                                }
                            }
                    case .modified:
                        let postId = diff.document.documentID
                        if let currentPost = self.posts.first(where: {$0.id == postId}),
                           let updateIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            let newPost = Post(dict:postData, id: postId, user: currentPost.user)
                            self.posts[updateIndex] = newPost
//                            self.packagesCollectionView.beginUpdates()
                            self.packagesCollectionView.deleteItems(at: [IndexPath(item: updateIndex, section: 0)])
                            
                            self.packagesCollectionView.insertItems(at: [IndexPath(item: updateIndex, section: 0)])
                    }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.posts.firstIndex(where: {$0.id == postId}){
                            self.posts.remove(at: deleteIndex)
                            self.packagesCollectionView.deleteItems(at: [IndexPath(item: deleteIndex, section: 0)])                        
                        }
            }
        }
    }
        }
            }
    // logout
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toPostVC" {
                let vc = segue.destination as! PostViewController
                vc.selectedPost = selectedPost
                vc.selectedPostImage = selectedPostImage
            }else if identifier == "toDetailsVC" {
                let vc = segue.destination as! DetailsViewController
                vc.selectedPost = selectedPost
                vc.selectedPostImage = selectedPostImage
            }
        }
     
    }
}
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.backgroundColor = .systemGray5
        return cell.configure(with: posts[indexPath.row])
        print("no dataaaaaaaa",posts[indexPath.row])
    }
}
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, sizeForItemAT indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.45, height: self.view.frame.width * 0.45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionView, insetForSrctionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCell
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

