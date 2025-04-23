//
//  LoginView.swift
//  Pixy
//
//  Created by Liza on 22/04/2025.
//

import UIKit

final class LoginView: UIView {
    
    let emailField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton(type: .system)
    let registerLinkButton = UIButton(type: .system)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func setupUI() {
        emailField.autocapitalizationType = .none
        emailField.borderStyle = .roundedRect
        emailField.keyboardType = .emailAddress
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        loginButton.setTitle("Log in", for: .normal)
        loginButton.setTitleColor(.secondaryLabel, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        registerLinkButton.setTitle("Don't have an account? Sign up", for: .normal)
        registerLinkButton.setTitleColor(.systemBlue, for: .normal)
        registerLinkButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerLinkButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(loginButton)
        addSubview(registerLinkButton)
        
        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            emailField.widthAnchor.constraint(equalToConstant: 280),
            
            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            registerLinkButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerLinkButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}



