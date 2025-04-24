//
//  WidgetViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//

import CoreData
import UIKit

class WidgetViewController: UIViewController {
    
    private let widgetView = WidgetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = widgetView
        setupActions()
        loadMessage()
    }
    
    private func setupActions() {
        widgetView.createButton.addTarget(self, action: #selector(openCreateMessage), for: .touchUpInside)
        widgetView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    private func loadMessage() {
        guard let currentEmail = UserDefaults(suiteName: "group.com.xzeu.pixy")?.string(forKey: "loggedInEmail") else {
            widgetView.messageLabel.text = "Wait for the message"
            widgetView.senderLabel.text = ""
            widgetView.dateLabel.text = ""
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        
        request.predicate = NSPredicate(format: "receiverEmail == %@", currentEmail)
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        request.fetchLimit = 1

        do {
            if let last = try context.fetch(request).first {
                widgetView.messageLabel.text = last.text ?? "No message"
                widgetView.senderLabel.text = "From: \(last.authorEmail ?? "Unknown")"

                if let date = last.created {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    widgetView.dateLabel.text = formatter.string(from: date)
                } else {
                    widgetView.dateLabel.text = ""
                }
            } else {
                widgetView.messageLabel.text = "No message"
                widgetView.senderLabel.text = ""
                widgetView.dateLabel.text = ""
            }
        } catch {
            widgetView.messageLabel.text = "Error loading message"
            widgetView.senderLabel.text = ""
            widgetView.dateLabel.text = ""
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
