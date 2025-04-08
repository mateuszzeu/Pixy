//
//  SecondViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//
import UIKit

protocol CreateMessageViewControllerDelegate: AnyObject {
    func didSaveText(_ text: String)
}

class CreateMessageViewController: UIViewController {
    
    weak var delegate: CreateMessageViewControllerDelegate?
    
    private let textField = UITextField()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.68, green: 0.79, blue: 0.90, alpha: 1)
        
        setupUI()
    }
    private func setupUI() {
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
        
        view.addSubview(textField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
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
        let text = textField.text ?? ""
        
        MessageStorage.shared.saveMessage(text: text)
        
        delegate?.didSaveText(text)
        
        navigationController?.popViewController(animated: true)
    }
}
