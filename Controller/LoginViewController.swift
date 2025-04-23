//
//  LoginViewController.swift
//  Pixy
//
//  Created by Liza on 09/04/2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = loginView
        setupActions()
    }
    
    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginView.registerLinkButton.addTarget(self, action: #selector(openRegister), for: .touchUpInside)
    }
    
    
    @objc private func loginTapped() {
        guard let email = loginView.emailField.text, !email.isEmpty,
              let password = loginView.passwordField.text, !password.isEmpty else {
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
   
