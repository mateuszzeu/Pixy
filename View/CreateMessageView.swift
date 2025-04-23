//
//  CreateMessageView.swift
//  Pixy
//
//  Created by Liza on 23/04/2025.
//

import UIKit

final class CreateMessageView: UIView {
    
    let receiverField = UITextField()
    let textField = UITextField()
    let saveButton = UIButton(type: .system)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func setupUI() {
        receiverField.borderStyle = .roundedRect
        receiverField.autocapitalizationType = .none
        receiverField.keyboardType = .emailAddress
        receiverField.translatesAutoresizingMaskIntoConstraints = false
        receiverField.attributedPlaceholder = NSAttributedString(
            string: "Send to",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Type your message",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel.withAlphaComponent(0.25),
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )
        
        saveButton.setTitle("Pix it! ✨", for: .normal)
        saveButton.setTitleColor(.secondaryLabel, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(receiverField)
        addSubview(textField)
        addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            receiverField.centerXAnchor.constraint(equalTo: centerXAnchor),
            receiverField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            receiverField.widthAnchor.constraint(equalToConstant: 250),
            
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            textField.widthAnchor.constraint(equalToConstant: 250),
            
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
