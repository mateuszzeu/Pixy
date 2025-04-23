//
//  RegisterViewController.swift
//  Pixy
//
//  Created by Liza on 09/04/2025.
//

import CoreData
import UIKit

class RegisterViewController: UIViewController {

    private let registerView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = registerView
        setupActions()
    }
    
    private func setupActions() {
        registerView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    @objc private func registerTapped() {
        guard let email = registerView.emailField.text, !email.isEmpty,
              let password = registerView.passwordField.text, !password.isEmpty else {
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
