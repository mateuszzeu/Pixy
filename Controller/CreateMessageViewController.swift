//
//  SecondViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//
import UIKit
import WidgetKit

protocol CreateMessageViewControllerDelegate: AnyObject {
    func didSaveText(_ text: String)
}

class CreateMessageViewController: UIViewController {
    
    private let createMessageView = CreateMessageView()
    
    weak var delegate: CreateMessageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = createMessageView
        setupActions()
    }
    
    private func setupActions() {
        createMessageView.saveButton.addTarget(self, action: #selector(sendPixTapped), for: .touchUpInside)
    }
    
    @objc func sendPixTapped() {
        guard let text = createMessageView.textField.text, !text.isEmpty,
              let receiver = createMessageView.receiverField.text, !receiver.isEmpty,
              let author = UserDefaults(suiteName: "group.com.xzeu.pixy")?.string(forKey: "loggedInEmail") else {
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let message = Message(context: context)
        message.text = text
        message.created = Date()
        message.authorEmail = author
        message.receiverEmail = receiver
        
        do {
            try context.save()
            delegate?.didSaveText(text)
            WidgetCenter.shared.reloadAllTimelines()
            navigationController?.popViewController(animated: true)
        } catch {
            assertionFailure("Failed to save message: \(error.localizedDescription)")
        }
    }
}

