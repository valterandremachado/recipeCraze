//
//  ForgotPasswordVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/11/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import Firebase

let SUCCESS_EMAIL_RESET = "We have sent you a password reset email. Please check your inbox and follow the instructions to reset your password."
let ERROR_EMAIL_RESET = "We were not able to sent you a reset email. Try again!"

class ForgotPasswordVC: UIViewController {
    
    
    // MARK: Properties
    lazy var descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        //        lbl.backgroundColor = .blue
        lbl.numberOfLines = 0 // 0 = as many lines as the label needs
        lbl.frame.origin.x = 32
        lbl.frame.origin.y = 32
        lbl.frame.size.width = view.bounds.width - 64
        lbl.font = .systemFont(ofSize: 15) // my UIFont extension
        //        lbl.textColor = UIColor.black
        lbl.sizeToFit()
        lbl.text = "Enter your email address to receive a password reset, a password reset link will be sent to your inbox."
        
        return lbl
    }()
    
    lazy var emailTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //        txtFld.backgroundColor = .blue
        let placeholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.placeholder = "Email"
        //        txtFld.borderStyle = .roundedRect
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        return txtFld
    }()
    
    
    
    lazy var sendBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemPink
        
        btn.setTitle("Reset password", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 6
        btn.tintColor = .systemGray4
        btn.addTarget(self, action: #selector(sendBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var separatorOne: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    lazy var emailStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailTxtFld, separatorOne])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        
        return sv
    }()
    
    lazy var forgotPwStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [descriptionLbl, emailStackView, sendBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalSpacing
        return sv
    }()
    
    lazy var cancelBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.backgroundColor = .rgb(red: 101, green: 183, blue: 180)
        btn.setTitle("Cancel", for: .normal)
        
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 10
        btn.tintColor = .systemPink
        btn.addTarget(self, action: #selector(cancelBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    private var indicator: ProgressIndicator?
    
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Setting up activity indicator
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.black, msg: "")
        indicator?.isHidden = true
        
        sendBtn.isEnabled = false
        
        setupView()
        handleForgotPwBtnUX()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Selectors
    @objc fileprivate func sendBtnPressed(){
        indicator?.isHidden = false
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        // validate text fields
        sendBtn.setTitle("", for: .normal)
        indicator!.start()
        
        guard let email = emailTxtFld.text, email != "" else {
            print("error trying to reset password")
            let alertController = UIAlertController(title: "error trying to reset password", message: "", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.sendBtn.setTitle("Reset password", for: .normal)
            self.view.isUserInteractionEnabled = true
            self.sendBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .rgb(red: 101, green: 183, blue: 180)
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        resetPassword(email: email)
        
    }
    
    @objc fileprivate func cancelBtnPressed(){
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    fileprivate func handleForgotPwBtnUX(){
        emailTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
    }
    
    @objc fileprivate func textFldDidChange(){
        guard let email = emailTxtFld.text, !email.isEmpty else {
            self.sendBtn.setTitleColor(.systemGray4, for: .normal)
            self.sendBtn.isEnabled = false
            return
        }
        
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.isEnabled = true
    }
    
    fileprivate func resetPassword(email: String){
        DispatchQueue.main.async {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error != nil {
                    //                    print(error!.localizedDescription)
                    var errorReader = "\(error!.localizedDescription)"
                    
                    if errorReader == "There is no user record corresponding to this identifier. The user may have been deleted."
                    {   // handles Email input error
                        errorReader = "Incorrect Email"
                        
                        let alertController = UIAlertController(title: errorReader, message: "The email you entered doesn't appear to belong to an account. Please check your email and try again.", preferredStyle: .alert)
                        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
                        // enable UX
                        self.indicator!.stop()
                        self.sendBtn.setTitle("Reset password", for: .normal)
                        print("Couldn't Reset password: " + error!.localizedDescription)
                        self.view.isUserInteractionEnabled = true
                        self.sendBtn.isEnabled = true
                        self.indicator?.isHidden = true
                        // presenting alertController
                        alertController.view.tintColor = .rgb(red: 101, green: 183, blue: 180)
                        alertController.addAction(tryAgainAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else {
                        
                        let alertController = UIAlertController(title: error!.localizedDescription, message: "", preferredStyle: .alert)
                        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
                        // enable UX
                        self.indicator!.stop()
                        self.sendBtn.setTitle("Reset password", for: .normal)
                        print("Couldn't Reset password: " + error!.localizedDescription)
                        self.view.isUserInteractionEnabled = true
                        self.sendBtn.isEnabled = true
                        self.indicator?.isHidden = true
                        // presenting alertController
                        alertController.view.tintColor = .rgb(red: 101, green: 183, blue: 180)
                        alertController.addAction(tryAgainAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
                else
                {
                    print("Email sent!")
                    
                    let alertController = UIAlertController(title: "Email Sent!", message: "Please check your inbox and follow the instructions to reset your password.", preferredStyle: .alert)
                    let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                    }
                    // enable UX
                    self.indicator!.stop()
                    self.sendBtn.setTitle("Reset password", for: .normal)
                    self.view.isUserInteractionEnabled = true
                    self.sendBtn.isEnabled = true
                    self.indicator?.isHidden = true
                    // presenting alertController
                    alertController.view.tintColor = .rgb(red: 101, green: 183, blue: 180)
                    alertController.addAction(tryAgainAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                } // end of first error block
            }
        }
        
    }
    
    // MARK: Functions/Methods (Handlers)
    fileprivate func setupView(){
        [cancelBtn, forgotPwStackView, indicator!].forEach({view.addSubview($0)})
        
        // setting up activity indicator
        indicator?.anchor(top: sendBtn.topAnchor, leading: view.leadingAnchor, bottom: sendBtn.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: view.frame.width/2 - 20, bottom: 0, right: 0))
        
        cancelBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 100, height: 40))
        
        forgotPwStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets.init(top: view.frame.height/10, left: 40, bottom: 0, right: 40))
        
        //        emailStackView.withHeight(100)
        emailStackView.withHeight(45)
        separatorOne.withHeight(0.8)
        sendBtn.withHeight(45)
    }
}
