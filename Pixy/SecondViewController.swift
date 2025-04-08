//
//  SecondViewController.swift
//  Pixy
//
//  Created by Liza on 07/04/2025.
//
import UIKit

protocol SecondViewControllerDelegate: AnyObject {
    func didSaveText(_ text: String)
}

class SecondViewController: UIViewController {
    
    weak var delegate: SecondViewControllerDelegate?
    
    var receivedText: String = ""
    
    private let textField = UITextField()
    private let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        
        textField.text = receivedText
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Zapisz", for: .normal)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            textField.widthAnchor.constraint(equalToConstant: 250),

            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func saveTapped() {
        let text = textField.text ?? ""
        
        MessageStorage.shared.saveMessage(text: text)
        
        delegate?.didSaveText(text)
        
        navigationController?.popViewController(animated: true)
    }
}
