//
//  LoginViewController.swift
//  Pixy
//
//  Created by Liza on 09/04/2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let registerLinkButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        emailField.borderStyle = .roundedRect
        //emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.quaternaryLabel.cgColor
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.textColor = .label
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )

        passwordField.borderStyle = .roundedRect
        //passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.quaternaryLabel.cgColor
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.textColor = .label
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )

        loginButton.setTitle("Log in", for: .normal)
        loginButton.setTitleColor(.secondaryLabel, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        loginButton.layer.shadowRadius = 2

        registerLinkButton.setTitle("Don't have an account? Sign up", for: .normal)
        registerLinkButton.setTitleColor(.systemBlue, for: .normal)
        registerLinkButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerLinkButton.addTarget(self, action: #selector(openRegister), for: .touchUpInside)
        registerLinkButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerLinkButton)

        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailField.widthAnchor.constraint(equalToConstant: 280),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            registerLinkButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    
    @objc private func loginTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Enter login information")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let request = PixyAccount.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(request)
            if let user = users.first {
                if user.password == password {
                    UserDefaults(suiteName: "group.com.xzeu.pixy")?.set(email, forKey: "loggedInEmail")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let mainVC = WidgetViewController()
                        self.navigationController?.setViewControllers([mainVC], animated: true)
                    }

                } else {
                    showAlert(title: "Error", message: "Wrong password")
                }
            } else {
                showAlert(title: "Error", message: "The user does not exist")
            }
        } catch {
            showAlert(title: "Error", message: "Failed to download data")
        }
    }
    
    @objc private func openRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
