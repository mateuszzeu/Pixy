//
//  WidgetViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//

import CoreData
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

        
        createButton.setTitle("Create message", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        createButton.setTitleColor(.white, for: .normal)
        createButton.addTarget(self, action: #selector(openCreateMessage), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.setTitle("Log out", for: .normal)
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
        guard let currentEmail = UserDefaults(suiteName: "group.com.xzeu.pixy")?.string(forKey: "loggedInEmail") else {
            messageLabel.text = "Wait for the message"
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        
        request.predicate = NSPredicate(format: "receiverEmail == %@", currentEmail)
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        request.fetchLimit = 1

        do {
            if let last = try context.fetch(request).first {
                messageLabel.text = last.text ?? "No message"
            } else {
                messageLabel.text = "No message"
            }
        } catch {
            messageLabel.text = "Error while loading message"
        }
    }

    @objc private func openCreateMessage() {
        let createVC = CreateMessageViewController()
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    @objc private func logoutTapped() {
        UserDefaults(suiteName: "group.com.xzeu.pixy")?.removeObject(forKey: "loggedInEmail")
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
    }
}


extension WidgetViewController: CreateMessageViewControllerDelegate {
    func didSaveText(_ text: String) {
        loadMessage()
    }
}
