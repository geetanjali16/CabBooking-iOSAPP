//
//  SignUpController.swift
//  ClickNride
//
//  Created by Geetanjali on 16/09/20.
//  Copyright © 2020 Geetanjali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "CLICKNRIDE"
           label.font = UIFont(name: "Avenir-Light", size: 36)
           label.textColor = UIColor(white: 1, alpha: 0.8)
           return label
       }()
    
    let emailContainerView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, height: 0.75)
        return view
       }()
       
       let emailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
        imageView.alpha = 0.87
        return imageView
       }()
       
       let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return textField
       }()
    
    let fullnameContainerView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, height: 0.75)
        return view
    }()
    
    let fullnameIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        imageView.alpha = 0.87
        return imageView
    }()
    
    let fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(string: "Fullname", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return textField
    }()
    
    let passwordContainerView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, height: 0.75)
        return view
    }()
       
    let passwordIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        imageView.alpha = 0.87
        return imageView
       }()
       
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return textField
       }()
    
    let accountTypeContainerView: UIView = {
        let view = UIView()
        let separatorView = UIView()
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, height: 0.75)
        return view
    }()
    
    let accountTypeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_account_box_white_2x")
        imageView.alpha = 0.87
        return imageView
    }()
    
    let accountTypeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Rider", "Driver"])
        segmentedControl.backgroundColor = .backgroundColor
        segmentedControl.tintColor = UIColor(white: 1, alpha: 0.87)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let signupButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton()
        let attributeTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes:
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
             NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributeTitle.append(NSMutableAttributedString(string: "Log In", attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
        }()
    
     // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to register user with error \(error)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "fullname": fullname,
                          "accountTpe": accountTypeIndex] as [String : Any]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                print("successfully registered user and saved data")
                
                guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return }
                controller.configureUI()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Function
    
    func setupUI() {
        
        view.backgroundColor = UIColor.backgroundColor
        
        let stack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fillProportionally
            stack.spacing = 16
            return stack
        }()
        
        view.addSubview(titleLabel)
        view.addSubview(stack)
        view.addSubview(alreadyHaveAccountButton)
        
        stack.addArrangedSubview(emailContainerView)
        stack.addArrangedSubview(fullnameContainerView)
        stack.addArrangedSubview(passwordContainerView)
        stack.addArrangedSubview(accountTypeContainerView)
        stack.addArrangedSubview(signupButton)
        
        emailContainerView.addSubview(emailIcon)
        emailContainerView.addSubview(emailTextField)
        
        fullnameContainerView.addSubview(fullnameIcon)
        fullnameContainerView.addSubview(fullnameTextField)
        
        passwordContainerView.addSubview(passwordIcon)
        passwordContainerView.addSubview(passwordTextField)
        
        accountTypeContainerView.addSubview(accountTypeIcon)
        accountTypeContainerView.addSubview(accountTypeSegmentedControl)
        
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        stack.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingLeading: 16, paddingTrailing: 16)
        
        emailIcon.centerY(inView: emailContainerView)
        emailIcon.anchor(leading: emailContainerView.leadingAnchor, paddingLeading: 8, width: 24, height: 24)
        
        emailTextField.anchor(leading: emailIcon.trailingAnchor, bottom: emailContainerView.bottomAnchor, trailing: emailContainerView.trailingAnchor, paddingLeading: 8, paddingBottom: 8)
        emailTextField.centerY(inView: emailContainerView)
        
        fullnameIcon.centerY(inView: fullnameContainerView)
        fullnameIcon.anchor(leading: fullnameContainerView.leadingAnchor, paddingLeading: 8, width: 24, height: 24)
              
        fullnameTextField.anchor(leading: fullnameIcon.trailingAnchor, bottom: fullnameContainerView.bottomAnchor, trailing: fullnameContainerView.trailingAnchor, paddingLeading: 8, paddingBottom: 8)
        fullnameTextField.centerY(inView: fullnameContainerView)
        
        passwordIcon.centerY(inView: passwordContainerView)
        passwordIcon.anchor(leading: passwordContainerView.leadingAnchor, paddingLeading: 8, width: 24, height: 24)
                 
        passwordTextField.centerY(inView: passwordContainerView)
        passwordTextField.anchor(leading: passwordIcon.trailingAnchor, bottom: passwordContainerView.bottomAnchor, trailing: passwordContainerView.trailingAnchor, paddingLeading: 8, paddingBottom: 8)
        
        accountTypeIcon.anchor(top: accountTypeContainerView.topAnchor, leading: accountTypeContainerView.leadingAnchor, paddingTop: -8,  paddingLeading: 8,  width: 24, height: 24)
        
        accountTypeSegmentedControl.anchor(leading: accountTypeContainerView.leadingAnchor, trailing: accountTypeContainerView.trailingAnchor, paddingLeading: 8, paddingTrailing: 8)
        accountTypeSegmentedControl.centerY(inView: accountTypeContainerView, constant: 8)
        
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        

        
    }
    

}
