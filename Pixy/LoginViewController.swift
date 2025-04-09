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
        emailField.placeholder = "Email"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField.placeholder = "Hasło"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.setTitle("Zaloguj się", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor.systemGreen
        loginButton.layer.cornerRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        registerLinkButton.setTitle("Nie masz konta? Zarejestruj się", for: .normal)
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
            showAlert(title: "Błąd", message: "Wprowadź dane logowania")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let request = PixyAccount.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(request)
            if let user = users.first {
                if user.password == password {
                    let mainVC = WidgetViewController()
                    navigationController?.setViewControllers([mainVC], animated: true)
                } else {
                    showAlert(title: "Błąd", message: "Nieprawidłowe hasło")
                }
            } else {
                showAlert(title: "Błąd", message: "Użytkownik nie istnieje")
            }
        } catch {
            showAlert(title: "Błąd", message: "Nie udało się pobrać danych")
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
