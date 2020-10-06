//
//  LoginController.swift
//  ClickNride
//
//  Created by Geetanjali on 15/09/20.
//  Copyright © 2020 Geetanjali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    
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
    
    let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton()
        let attributeTitle = NSMutableAttributedString(string: "Don't have an account?   ", attributes:
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
             NSMutableAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributeTitle.append(NSMutableAttributedString(string: "Sign Up", attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
             NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("failed to login with error \(error.localizedDescription)")
            }else{
                
                guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController else { return }
                controller.configureUI()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    @objc func handleShowSignUp() {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helper Function
    
    
    func setupUI() {
        
        view.backgroundColor = .backgroundColor
        
        configureNavigationBar()
          
          let stack: UIStackView = {
              let stack = UIStackView()
              stack.axis = .vertical
              stack.distribution = .fillEqually
              stack.spacing = 16
              return stack
          }()

              
          view.addSubview(titleLabel)
          view.addSubview(stack)
          
          stack.addArrangedSubview(emailContainerView)
          stack.addArrangedSubview(passwordContainerView)
          stack.addArrangedSubview(loginButton)
          
          emailContainerView.addSubview(emailIcon)
          emailContainerView.addSubview(emailTextField)
          passwordContainerView.addSubview(passwordIcon)
          passwordContainerView.addSubview(passwordTextField)
          
          view.addSubview(dontHaveAccountButton)
          
          titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 5)
          titleLabel.centerX(inView: view)
          
          stack.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingLeading: 16, paddingTrailing: 16)
          
          emailIcon.centerY(inView: emailContainerView)
          emailIcon.anchor(leading: emailContainerView.leadingAnchor, paddingLeading: 8, width: 24, height: 24)
          
          emailTextField.anchor(leading: emailIcon.trailingAnchor, bottom: emailContainerView.bottomAnchor, trailing: emailContainerView.trailingAnchor, paddingLeading: 8, paddingBottom: 8)
          emailTextField.centerY(inView: emailContainerView)


          passwordIcon.centerY(inView: passwordContainerView)
          passwordIcon.anchor(leading: passwordContainerView.leadingAnchor, paddingLeading: 8, width: 24, height: 24)
          
          passwordTextField.centerY(inView: passwordContainerView)
          passwordTextField.anchor(leading: passwordIcon.trailingAnchor, bottom: passwordContainerView.bottomAnchor, trailing: passwordContainerView.trailingAnchor, paddingLeading: 8, paddingBottom: 8)
          
          dontHaveAccountButton.centerX(inView: view)
          dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
          
      }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

}

