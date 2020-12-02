//
//  LoginVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/11/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import LBTATools
import Firebase

class LoginVC: UIViewController {
    
    var didFetchUserInfo = false
    
    // UserAuthViewModel
    var userAuthViewModel = UserAuthViewModel.shared
    
    fileprivate var defaults = UserDefaults.standard
    
    let imageBackground = UIImage(named: "balance.jpg")
    let logo = UIImage(named: "guidetech-06.png")
    
    lazy var separatorOne: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var separatorTwo: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
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
    
    lazy var passwordTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //        txtFld.backgroundColor = .red
        //        txtFld.borderStyle = .roundedRect
        let placeholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.isSecureTextEntry = true
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var loginBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemPink
        btn.setTitle("Continue", for: .normal)
        
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 6
        btn.tintColor = .systemGray4
        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var forgotPwBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.backgroundColor = .yellow
        btn.setTitle("Forgot Password?", for: .normal)
        
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        //        btn.layer.cornerRadius = 10
        btn.titleLabel?.textAlignment = .right
        btn.tintColor = .systemPink
        btn.addTarget(self, action: #selector(forgotPWBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var noAccLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = "Don't have an account?"
        //          lb.font = .boldSystemFont(ofSize: 50)
        lbl.textAlignment = .right
        lbl.textColor = .black
        
        
        //        lb.sizeToFit()
        //          lb.backgroundColor = .gray
        return lbl
    }()
    
    lazy var signupLinkBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.backgroundColor = .red
        btn.setTitle("Sign Up", for: .normal)
        
        btn.titleLabel?.textAlignment = .right
        btn.tintColor = .rgb(red: 101, green: 183, blue: 180)
        
        //        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        //        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(signupLinkPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var emailStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailTxtFld, separatorOne])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var passwordStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [passwordTxtFld, separatorTwo])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var loginStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, loginBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalSpacing
        return sv
    }()
    
    lazy var labelsStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [noAccLbl, signupLinkBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 3
        sv.distribution = .fillProportionally
        sv.alignment = .center
        //        sv.backgroundColor = .blue
        
        return sv
    }()
    
    private var indicator: ProgressIndicator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupKeyboardListener()
        setupActivityIndicator()
        
        loginBtn.isEnabled = false
        
        setupView()
        checkFirstTimeUser()
        handleLoginBtnUX()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Singleton delegate
        userAuthViewModel.delegate = self
        
        // Remove keyboard's height observer from signUpVC
        NotificationCenter.default.removeObserver(self)
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Functions
    fileprivate func setupView(){
        [loginStackView, forgotPwBtn, indicator!].forEach({view.addSubview($0)})
        
        let backButton = UIBarButtonItem()
        
        backButton.title = ""
        navigationItem.title = "Sign In"
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .systemPink
        
        // setting up activity indicator
        indicator?.anchor(top: loginBtn.topAnchor, leading: view.leadingAnchor, bottom: loginBtn.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: view.frame.width/2 - 20, bottom: 0, right: view.frame.width/2 - 20))
                
        loginStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets.init(top: 10, left: 20, bottom: 0, right: 20))
        
        forgotPwBtn.anchor(top: loginStackView.bottomAnchor, leading: loginStackView.leadingAnchor, bottom: nil, trailing: loginStackView.trailingAnchor, padding: UIEdgeInsets.init(top: 5, left: view.frame.width/8.5, bottom: 0, right: view.frame.width/8.5))
        
        emailStackView.withHeight(45)
//        passwordStackView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize.init(width: view.frame.width - 80, height: 45))
        passwordStackView.withHeight(45)
        separatorOne.withHeight(1)
        separatorTwo.withHeight(1)
        loginBtn.withHeight(45)
//        forgotPwBtn.withWidth(60)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.hideNavBarSeperator()
    }
    
    fileprivate func handleLoginBtnUX(){
        /// Handles accessibility to the SingUp button
        emailTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        
        /// Handles separator color changing
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
    }
    
    fileprivate func assignbackground(){
        let background = UIImage(named: "AbstractDark.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    fileprivate func setupKeyboardListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupActivityIndicator(){
        // Setting up activity indicator
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.black, msg: "")
        indicator?.isHidden = true
    }
    
    fileprivate func checkFirstTimeUser(){
        // MARK: Shows the view when user open it for the first time
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey:"isFirstTime")
            defaults.synchronize()
        }
        
    }
    
    // MARK: - Selectors
    @objc fileprivate func textFldEditingDidBegin(txtFld: UITextField){
        
        if emailTxtFld.isEditing == true {
            separatorOne.backgroundColor = .systemPink
            
        } else if passwordTxtFld.isEditing == true {
            separatorTwo.backgroundColor = .systemPink
            
        }
    }
    
    @objc fileprivate func textFldEditingDidEnd(txtFld: UITextField){
        separatorOne.backgroundColor = .lightGray
        separatorTwo.backgroundColor = .lightGray
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if view.bounds.height <= 667{
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (keyboardSize.height - keyboardSize.height) + 70
                }
            }
        } else {
            print("bigger size screen")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.bounds.height <= 667{
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        } else {
            print("bigger size screen")
        }
    }
    
    @objc func signupLinkPressed(){
        view.endEditing(true)
        let signupVC = SignupVC()
        //        self.present(signupVC, animated: true)
        signupVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @objc func loginBtnPressed(){
        indicator?.isHidden = false
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        // validate text fields
        loginBtn.setTitle("", for: .normal)
        indicator!.start()
        
        // creates clean version of textfield
        guard let email = emailTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let password = passwordTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        else { return }
        
        // SignIn user
        userAuthViewModel.signInUserWith(email, password)
    }
    
    @objc func forgotPWBtnPressed(){
        view.endEditing(true)
        let forgotPwVC = ForgotPasswordVC()
        present(forgotPwVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func textFldDidChange(){
        guard let email = emailTxtFld.text, !email.isEmpty, let password = passwordTxtFld.text, !password.isEmpty else {
            self.loginBtn.setTitleColor(.systemGray4, for: .normal)
            self.loginBtn.isEnabled = false
            return
        }
        
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.isEnabled = true
    }
}


// MARK: - UserAuthSingleton Extension
extension LoginVC: UserAuthSingleton {
    
    // Error Handler
    func userAuthCallBack(errorMessage: String) {
        var errorReader = errorMessage
        if errorReader == "There is no user record corresponding to this identifier. The user may have been deleted."
        {   // handles Email input error
            errorReader = "Incorrect Email"
            
            let alertController = UIAlertController(title: errorReader, message: "The email you entered doesn't appear to belong to an account. Please check your email and try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.loginBtn.setTitle("Continue", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if errorReader == "The password is invalid or the user does not have a password." {
            // handles password input error
            errorReader = "Incorrect Password"
            
            let alertController = UIAlertController(title: errorReader, message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.loginBtn.setTitle("Continue", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        }  else if errorReader == "Network error (such as timeout, interrupted connection or unreachable host) has occurred." {
            // handles time out error
            errorReader = "Connection Issue"
            
            let alertController = UIAlertController(title: errorReader, message: "We are having problem to connect with our server. Please try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.loginBtn.setTitle("Continue", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else if errorReader == "Too many unsuccessful login attempts. Please try again later." {
            // handles Too many unsuccessful login attempts error
            errorReader = "Forgot Password?"
            
            let alertController = UIAlertController(title: errorReader, message: "You entered many times a wrong password. Do you want to reset your password?.", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { UIAlertAction in
                let forgotPwVC = ForgotPasswordVC()
                self.present(forgotPwVC, animated: true, completion: nil)
            }
            
            let tryAgainAction = UIAlertAction(title: "No", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.loginBtn.setTitle("Continue", for: .normal)
            print("Couldn't sign in: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.loginBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(yesAction)
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        let alertController = UIAlertController(title: errorReader, message: "", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
        // enable UX
        self.indicator!.stop()
        self.loginBtn.setTitle("Continue", for: .normal)
        print("Couldn't sign in: " + errorReader)
        self.view.isUserInteractionEnabled = true
        self.loginBtn.isEnabled = true
        self.indicator?.isHidden = true
        // presenting alertController
        alertController.view.tintColor = .systemPink
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // User Signed in successfully
    func didEndFetchingUserInfo(didFetchInfo state: Bool, firstName: String, lastName: String, email: String, profileImageUrl: String, numberOfFaveRecipes: Int) {
        didFetchUserInfo = state
        print("Value: \(didFetchUserInfo)")
        print("signed in successfully")
        
        self.indicator!.stop()
        self.loginBtn.setTitle("Continue", for: .normal)
        self.view.isUserInteractionEnabled = state
        self.indicator?.isHidden = state
//        let test = TestVC()
//        test.test = name
//        self.present(test, animated: true)
        
        // Switch rootView in order to avoid memory leak as well as stack of views
        let mainVC = TabController()
//        mainVC.homeVC.userNameLabel.text = name
//        mainVC.homeVC.userEmailLabel.text = email
//        mainVC.homeVC.welcomingLabel.text = "Hello, \(name)!"

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC)

    }
    
    
}
