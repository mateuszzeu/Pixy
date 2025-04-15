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
    
    weak var delegate: CreateMessageViewControllerDelegate?
    
    private let receiverField = UITextField()
    private let textField = UITextField()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        receiverField.borderStyle = .roundedRect
        receiverField.autocapitalizationType = .none
        receiverField.keyboardType = .emailAddress
        receiverField.translatesAutoresizingMaskIntoConstraints = false
        receiverField.textColor = .label
        receiverField.attributedPlaceholder = NSAttributedString(
            string: "Send to",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .label
        textField.attributedPlaceholder = NSAttributedString(
            string: "Type your message...",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        saveButton.setTitle("Pix it! ✨", for: .normal)
        saveButton.setTitleColor(.secondaryLabel, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        saveButton.layer.shadowRadius = 2
        
        view.addSubview(receiverField)
        view.addSubview(textField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            receiverField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            receiverField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            receiverField.widthAnchor.constraint(equalToConstant: 250),
            
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            textField.widthAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func saveTapped() {
        guard let text = textField.text, !text.isEmpty,
              let receiver = receiverField.text, !receiver.isEmpty,
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

