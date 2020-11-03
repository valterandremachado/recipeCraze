//
//  UserProfileVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/24/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    
    // MARK: - Properties
    lazy var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    lazy var transparentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        return view
    }()
    
    lazy var centerHandlerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dismiss(animated: true, completion: nil)
//    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        view.addSubview(customView)
//        transparentView.addSubview(customView)
        [centerHandlerView].forEach({customView.addSubview($0)})
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
//        transparentView.addGestureRecognizer(tap)
        
        customView.withHeight(200)
        customView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//        transparentView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//        customView3.anchor(top: customView.topAnchor, leading: nil, bottom: nil, trailing: nil)
        centerHandlerView.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
        centerHandlerView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8).isActive = true
        centerHandlerView.withHeight(5)
        centerHandlerView.withWidth(80)

    }
    
    // MARK: - Selectors
    @objc fileprivate func viewTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
