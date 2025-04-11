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
        view.backgroundColor = UIColor(red: 0.68, green: 0.79, blue: 0.90, alpha: 1)
        
        setupUI()
    }
    private func setupUI() {
        receiverField.placeholder = "Email odbiorcy"
        receiverField.borderStyle = .roundedRect
        receiverField.autocapitalizationType = .none
        receiverField.keyboardType = .emailAddress
        receiverField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Wpisz wiadomość"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Zapisz wiadomość", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: textField.widthAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
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
                assertionFailure("Nie udało się zapisać wiadomości: \(error.localizedDescription)")
            }
        }
    }
