//
//  ViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//

import UIKit

class ViewController: UIViewController {
    
    let textField = UITextField()
    let button = UIButton(type: .system)
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPurple
        
        if let last = MessageStorage.shared.fetchLastMessage() {
            label.text = "Z CoreData: \(last.text ?? "brak")"
        } else {
            label.text = "Brak danych z CoreData"
        }
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Wpisz coś dla Kamilki"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle("Zapisz do Core Data", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(goToSecondScreen), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 250),
            
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func goToSecondScreen() {
        let text = textField.text ?? ""
        MessageStorage.shared.saveMessage(text: text)
        label.text = "Zapisano: \(text)"
    }
}

extension ViewController: SecondViewControllerDelegate {
    func didSaveText(_ text: String) {
        label.text = "Otrzymano od drugiego widoku: \(text)"
    }
}

