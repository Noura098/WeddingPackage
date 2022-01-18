//
//  PostViewController.swift
//  weddingPackage
//
//  Created by NoON .. on 23/05/1443 AH.
//

import UIKit
import Firebase
class PostViewController: UIViewController {
    var selectedPost:Post?
    var selectedPostImage:UIImage?
    @IBOutlet weak var postDescriptionTV: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet {
            descriptionLabel.text =  "Description".localized
        }
    }
    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var postImageView: UIImageView!{
        didSet {
            postImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            postImageView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var postPackageNameTF: UITextField!
    @IBOutlet weak var packageNameLabel: UILabel!{
        didSet {
            packageNameLabel.text = "packageName".localized
        }
    }
    
    @IBOutlet weak var postPriceTF: UITextField!
    @IBOutlet weak var priceLabel: UILabel!{
        didSet {
            priceLabel.text = "Price".localized
        }
    }
    
    @IBOutlet weak var veiwPost: UIView! {
        didSet{
            // code shado
            veiwPost.layer.masksToBounds = true
            veiwPost.layer.cornerRadius = 15
            veiwPost.layer.masksToBounds = false
            veiwPost.layer.shadowOffset = CGSize(width: 0, height: 0)
            veiwPost.layer.shadowColor = UIColor.black.cgColor
            veiwPost.layer.shadowOpacity = 0.5
            veiwPost.layer.cornerRadius = 5
        }
    }
    
    let activityIndicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        
        if let selectedPost = selectedPost,
        let selectedImage = selectedPostImage{
            postPackageNameTF.text = selectedPost.namePackage
            postPriceTF.text = selectedPost.price
            postDescriptionTV.text = selectedPost.description
            postImageView.image = selectedImage
            addButton.setTitle("Update Post".localized, for: .normal)
            let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
            self.navigationItem.rightBarButtonItem = deleteBarButton
        }else {
            addButton.setTitle("Add Post".localized, for: .normal)
            self.navigationItem.rightBarButtonItem = nil
            
        }
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(self.doneClicked))
        doneButton.tintColor = .label
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        postDescriptionTV.inputAccessoryView = toolBar
        postPackageNameTF.inputAccessoryView = toolBar
        postPriceTF.inputAccessoryView = toolBar
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func doneClicked () {
        view.endEditing(true)
    }
    @objc func handleDelete (_ sender: UIBarButtonItem) {
        let ref = Firestore.firestore().collection("posts")
        if let selectedPost = selectedPost {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            ref.document(selectedPost.id).delete { error in
                if let error = error {
                    print("Error in db delete",error)
                }else{
                    // Create a reference to the file to delete
                    print(selectedPost.user.id,selectedPost.id)
                    let storageRef = Storage.storage().reference(withPath: "posts/\(selectedPost.user.id)/\(selectedPost.id)")
                    // Delete the file
                    storageRef.delete { error in
                        if let error = error {
                            print("Error in storage delete",error)
                        }else{
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                }
            }
        }
    }
    @IBAction func addActionButton(_ sender: Any) {
        if let image = postImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
           let packageName = postPackageNameTF.text,
           let description = postDescriptionTV.text,
           let price = postPriceTF.text,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            var postId = ""
            if let selectedPost = selectedPost {
                postId = selectedPost.id
                print("postId errrrorr",postId)
            }else {
                postId = "\(Firebase.UUID())"
            }
            let storageRef = Storage.storage().reference(withPath: "posts/\(currentUser.uid)/\(postId)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData,metadata: updloadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload errrrror",error.localizedDescription)
                }
                storageRef.downloadURL {url, error in
                    var postData = [String:Any]()
                    if let url = url {
                        let db = Firestore.firestore()
                        let ref = db.collection("posts")
                        if let selectedPost = self.selectedPost {
                            postData = [
                                "userId":selectedPost.user.id,
                                "price":price,
                                "packageName":packageName,
                                "description":description,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }else{
                            postData = [
                                "userId":currentUser.uid,
                                "price":price,
                                "packageName":packageName,
                                "description":description,
                                "imageUrl":url.absoluteString,
                                "createdAt":FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                            print("postData errorr",postData)
                        }
                        ref.document(postId).setData(postData) { error in
                            if let error = error {
                                print("FireStore Error",error.localizedDescription)
                            }
                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            self.navigationController?.popViewController(animated: true)
                }
                
            }
    }
}
}
    }
}
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func chooseImage() {
        self.showAlert()
    }
    private func showAlert() {
        
        let alert = UIAlertController(title: "Choose Profile Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
       postImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
