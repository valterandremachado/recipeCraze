//
//  PopUpWindow.swift
//  PopUpWindow
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

protocol PopUpDelegate {
    func handleDismissal()
}

class PopUpWindow: UIView {

    // MARK: - Properties
    
    var delegate: PopUpDelegate?
    
    var showSuccessMessage: Bool? {
        didSet {
            guard let success = showSuccessMessage else { return }
            if success {
                checkLabel.text = "✓"
                notificationLabel.text = "Added"
                checkLabel.textColor = .systemPink
            } else {
                checkLabel.text = "X"
                notificationLabel.text = "Removed"
                checkLabel.textColor = .systemPink
            }
        }
    }
    
    let checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 50)
        
        return label
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 15)
        label.textColor = .white
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        addSubview(checkLabel)
        checkLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        checkLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(notificationLabel)
        notificationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notificationLabel.topAnchor.constraint(equalTo: checkLabel.bottomAnchor, constant: 0).isActive = true
        
//        addSubview(button)
//        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        button.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
//        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
//        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
}
