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
        view.backgroundColor = UIColor.systemBackground
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

        registerButton.setTitle("Zarejestruj się", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = UIColor.systemBlue
        registerButton.layer.cornerRadius = 8
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

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
            showAlert(title: "Błąd", message: "Wprowadź poprawne dane")
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let request = PixyAccount.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)

        do {
            let existing = try context.fetch(request)
            if !existing.isEmpty {
                showAlert(title: "Błąd", message: "Konto o podanym adresie e-mail już istnieje")
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
            showAlert(title: "Błąd", message: "Nie udało się zapisać użytkownika")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
