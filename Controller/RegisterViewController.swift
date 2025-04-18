//
//  RegisterViewController.swift
//  Pixy
//
//  Created by Liza on 09/04/2025.
//

import CoreData
import UIKit

class RegisterViewController: UIViewController {

    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let registerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        emailField.borderStyle = .roundedRect
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

        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.secondaryLabel, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOpacity = 0.2
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        registerButton.layer.shadowRadius = 2

        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)

        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailField.widthAnchor.constraint(equalToConstant: 280),

            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor),

            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            registerButton.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func registerTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Enter the correct data")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let request = PixyAccount.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)

        do {
            let existing = try context.fetch(request)
            if !existing.isEmpty {
                showAlert(title: "Error", message: "An account with the specified email address already exists")
                return
            }

            let newUser = PixyAccount(context: context)
            newUser.email = email
            newUser.password = password
            newUser.created = Date()
            newUser.id = UUID()

            try context.save()
            UserDefaults(suiteName: "group.com.xzeu.pixy")?.set(email, forKey: "loggedInEmail")

            let mainVC = WidgetViewController()
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(title: "Error", message: "Failed to save user")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
