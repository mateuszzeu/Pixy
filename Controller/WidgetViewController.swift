//
//  WidgetViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//

import CoreData
import UIKit

class WidgetViewController: UIViewController {
    
    private let messageContainer = UIView()
    private let messageLabel = UILabel()
    private let senderLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let createButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        loadMessage()
    }

    private func setupUI() {
        messageContainer.backgroundColor = UIColor.systemGray6
        messageContainer.layer.cornerRadius = 20
        messageContainer.layer.masksToBounds = true
        messageContainer.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .label
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        senderLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        senderLabel.textColor = .secondaryLabel
        senderLabel.textAlignment = .center
        senderLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        messageContainer.addSubview(messageLabel)
        messageContainer.addSubview(senderLabel)
        messageContainer.addSubview(dateLabel)
        view.addSubview(messageContainer)

        createButton.setTitle("Send a Pix ✨", for: .normal)
        createButton.setTitleColor(.secondaryLabel, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(openCreateMessage), for: .touchUpInside)
        createButton.layer.shadowColor = UIColor.black.cgColor
        createButton.layer.shadowOpacity = 0.2
        createButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        createButton.layer.shadowRadius = 2

        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.setTitleColor(.secondaryLabel, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)

        view.addSubview(createButton)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            messageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            messageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            messageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            messageContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            messageLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -16),

            senderLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -4),
            senderLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 16),
            senderLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -16),

            dateLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -16),

            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func loadMessage() {
        guard let currentEmail = UserDefaults(suiteName: "group.com.xzeu.pixy")?.string(forKey: "loggedInEmail") else {
            messageLabel.text = "Wait for the message"
            senderLabel.text = ""
            dateLabel.text = ""
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
                senderLabel.text = "From: \(last.authorEmail ?? "Unknown")"

                if let date = last.created {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    dateLabel.text = formatter.string(from: date)
                } else {
                    dateLabel.text = ""
                }
            } else {
                messageLabel.text = "No message"
                senderLabel.text = ""
                dateLabel.text = ""
            }
        } catch {
            messageLabel.text = "Error loading message"
            senderLabel.text = ""
            dateLabel.text = ""
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
