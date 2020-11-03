//
//  PopUpWindow.swift
//  PopUpWindow
//
//  Created by Stephen Dowless on 12/13/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

protocol CustomizedPopUpViewDelegate {
    func handleDismissal()
}

class CustomizedPopUpView: UIView {

    // MARK: - Properties
    var delegate: CustomizedPopUpViewDelegate?
    
    var showSuccessMessage: Bool? {
        didSet {
            guard let success = showSuccessMessage else { return }
            if success {
                checkLabel.text = "✓"
                notificationLabel.text = "Success"
                checkLabel.textColor = UIColor(red: 147/255, green: 227/255, blue: 105/255, alpha: 1)
            } else {
                checkLabel.text = "X"
                notificationLabel.text = "Error"
                checkLabel.textColor = .red
            }
        }
    }
      
    var stepperView: UIStepper = {
        let stepper = UIStepper(frame: CGRect(x: (UIScreen.main.bounds.width - 200)/2 , y: (UIScreen.main.bounds.height - 500)/2, width: 0, height: 0))
        stepper.translatesAutoresizingMaskIntoConstraints = true
        stepper.backgroundColor = .red
        return stepper
    }()
    
    let checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 96)
        
        return label
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir", size: 24)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.systemPink
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
//        addSubview(stepperView)
//        stepperView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -28).isActive = true
//        stepperView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -100).isActive = true
//        stepperView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
//        addSubview(notificationLabel)
//        notificationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        notificationLabel.topAnchor.constraint(equalTo: stepperView.bottomAnchor, constant: 0).isActive = true
//
        addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
}
