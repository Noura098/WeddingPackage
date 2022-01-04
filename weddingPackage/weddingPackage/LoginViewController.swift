//
//  LoginViewController.swift
//  weddingPackage
//
//  Created by NoON .. on 17/05/1443 AH.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var emailLabel: UILabel!{
        didSet {
            emailLabel.text = "email".localized
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet {
            passwordLabel.text = "password".localized
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!{
        didSet{
            signinButton.setTitle("Signin".localized, for: .normal)
        }
    }
    @IBOutlet weak var newCustomerLabel: UILabel!{
        didSet {
            newCustomerLabel.text = "NewCustomer".localized
        }
    }
    @IBOutlet weak var signinLabel: UILabel!{
        didSet {
            signinLabel.text = "Signin".localized
        }
    }
    @IBOutlet weak var createButton: UIButton!
    {
        didSet{
            createButton.setTitle("createyourAccount".localized, for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(self.doneClicked))

        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
       
       passwordTextField.inputAccessoryView = toolBar
    }
    @objc func doneClicked () {
        view.endEditing(true)
    }
    @IBAction func handleLogin(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @IBAction func iconAction(_ sender: AnyObject) {
        passwordTextField.isSecureTextEntry.toggle()
           if passwordTextField.isSecureTextEntry {
               if let image = UIImage(systemName: "eye.slash.fill") {
                   sender.setImage(image, for: .normal)
               }
           } else {
               if let image = UIImage(systemName: "eye.fill") {
                   sender.setImage(image, for: .normal)
               }
           }
       }
    }
