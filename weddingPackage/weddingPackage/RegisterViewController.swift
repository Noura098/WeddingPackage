//
//  RegisterViewController.swift
//  weddingPackage
//
//  Created by NoON .. on 17/05/1443 AH.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var userImageView: UIImageView!{
        didSet {
            userImageView.layer.borderColor = UIColor.systemGreen.cgColor
            userImageView.layer.borderWidth = 3.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameLabel: UILabel!
    {
        didSet {
            firstNameLabel.text = "firstName".localized
        }
    }
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!{
        didSet {
            lastNameLabel.text = "lastName".localized
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!{
        didSet {
            emailLabel.text = "email".localized
        }
    }
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!{
        didSet {
            cityLabel.text = "city".localized
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet {
           passwordLabel.text = "password".localized
        }
    }
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!{
        didSet {
          confirmPasswordLabel.text = "passwordComfirm".localized
        }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.setTitle("regester".localized, for: .normal)
        }
    }
    @IBOutlet weak var eyeP1: UIButton!
    @IBOutlet weak var eyeCP: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.rightView = eyeP1
        passwordTextField.rightViewMode = .whileEditing
        confirmPasswordTextField.rightView = eyeCP
        confirmPasswordTextField.rightViewMode = .whileEditing
        
        imagePickerController.delegate = self
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
    
    @IBAction func handleRegister(_ sender: Any) {
    if let image = userImageView.image,
       let imageData = image.jpegData(compressionQuality: 0.75),
       let firstName = firstNameTextField.text,
       let lastName = lastNameTextField.text,
       let city = cityTextField.text,
       let email = emailTextField.text,
       let password = passwordTextField.text,
       let confirmPassword = confirmPasswordTextField.text,
       password == confirmPassword {
        Activity.showIndicator(parentView: self.view, childView: activityIndicator)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                print("Registration Auth Error",error.localizedDescription)
            }
            if let authResult = authResult {
                let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                let uploadMeta = StorageMetadata.init()
                uploadMeta.contentType = "image/jpeg"
                storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                    if let error = error {
                        Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        print("Registration Storage Error",error.localizedDescription)
                    }
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            print("Registration Storage Download Url Error",error.localizedDescription)
                        }
                        if let url = url {
                            print("URL",url.absoluteString)
                            let db = Firestore.firestore()
                            let userData: [String:String] = [
                                "id":authResult.user.uid,
                                "firstName":firstName,
                                "lastName":lastName,
                                "city":city,
                                "email":email,
                                "imageUrl":url.absoluteString
                            ]
                            db.collection("users").document(authResult.user.uid).setData(userData) { error in
                                if let error = error {
                                    print("Registration Database error",error.localizedDescription)
                                }else {
                                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                                        vc.modalPresentationStyle = .fullScreen
                                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
    @IBAction func changePasswordVisibility(_ sender: AnyObject) {
        passwordTextField.isSecureTextEntry.toggle()
           if passwordTextField.isSecureTextEntry {
               if let image = UIImage(systemName: "eye.fill") {
                   sender.setImage(image, for: .normal)
               }
           } else {
               if let image = UIImage(systemName: "eye.slash.fill") {
                   sender.setImage(image, for: .normal)
               }
           }
       }
    @IBAction func changePasswordCMVisibility(_ sender: AnyObject) {
        confirmPasswordTextField.isSecureTextEntry.toggle()
           if confirmPasswordTextField.isSecureTextEntry {
               if let image = UIImage(systemName: "eye.fill") {
                   sender.setImage(image, for: .normal)
               }
           } else {
               if let image = UIImage(systemName: "eye.slash.fill") {
                   sender.setImage(image, for: .normal)
               }
           }
    }
}
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @objc func selectImage() {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galaryAction = UIAlertAction(title: "photo Album", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .destructive) { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getImage( from sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return}
        userImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
