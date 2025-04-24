//
//  WidgetView.swift
//  Pixy
//
//  Created by Liza on 23/04/2025.
//

import UIKit

final class WidgetView: UIView {
    
    let messageContainer = UIView()
    let messageLabel = UILabel()
    let senderLabel = UILabel()
    let dateLabel = UILabel()
    
    let createButton = UIButton(type: .system)
    let logoutButton = UIButton(type: .system)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func setupUI() {
        messageContainer.backgroundColor = UIColor.systemGray6
        messageContainer.layer.cornerRadius = 20
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        senderLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        senderLabel.textColor = .secondaryLabel
        senderLabel.textAlignment = .center
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        dateLabel.textColor = .tertiaryLabel
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        createButton.setTitle("Send a Pix ✨", for: .normal)
        createButton.setTitleColor(.secondaryLabel, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.setTitleColor(.secondaryLabel, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        messageContainer.addSubview(messageLabel)
        messageContainer.addSubview(senderLabel)
        messageContainer.addSubview(dateLabel)
        
        addSubview(messageContainer)
        addSubview(createButton)
        addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            messageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            messageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
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

            createButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
