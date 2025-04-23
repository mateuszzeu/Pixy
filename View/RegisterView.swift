//
//  RegisterView.swift
//  Pixy
//
//  Created by Liza on 23/04/2025.
//

import UIKit

final class RegisterView: UIView {
    
    let emailField = UITextField()
    let passwordField = UITextField()
    let registerButton = UIButton(type: .system)
    
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
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.secondaryLabel, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 18)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            emailField.widthAnchor.constraint(equalToConstant: 280),

            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor),

            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            registerButton.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
