//
//  WidgetViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//

import UIKit

class WidgetViewController: UIViewController {
    
    private let messageLabel = UILabel()
    private let createButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.68, green: 0.79, blue: 0.90, alpha: 1)



        setupUI()
        loadMessage()
    }

    private func setupUI() {
        
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        
        createButton.setTitle("Utwórz wiadomość", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        createButton.setTitleColor(.white, for: .normal)
        createButton.addTarget(self, action: #selector(openCreateMessage), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.setTitle("Wyloguj się", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)

        
        view.addSubview(messageLabel)
        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            createButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func loadMessage() {
        if let last = MessageStorage.shared.fetchLastMessage() {
            messageLabel.text = "\(last.text ?? "Brak wiadomości")"
        } else {
            messageLabel.text = "Brak wiadomości do wyświetlenia"
        }
    }

    @objc private func openCreateMessage() {
        let createVC = CreateMessageViewController()
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    @objc private func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: "loggedInEmail")
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
    }
}


extension WidgetViewController: CreateMessageViewControllerDelegate {
    func didSaveText(_ text: String) {
        messageLabel.text = text
    }
}
