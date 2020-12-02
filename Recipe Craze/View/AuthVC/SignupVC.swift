//
//  SignupVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/11/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import LBTATools
import Firebase

class SignupVC: UIViewController {
    
    // MARK: - UserAuthViewModel
    var userRegistrationViewModel = UserRegistrationViewModel.shared
    
    let imageBackground = UIImage(named: "balance.jpg")
    
    var selectedImage: UIImage?
    
    lazy var profileImageViewPicker: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        iv.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.clipsToBounds = true
        //        iv.sizeToFit()
        iv.contentMode = .scaleAspectFill
        //        iv.backgroundColor = .red
        return iv
    }()
    
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
    
    lazy var separatorThree: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var separatorFour: UIView = {
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
        
        let placeholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.isSecureTextEntry = true
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var firstNameTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //                txtFld.backgroundColor = .red
        
        let placeholder = NSAttributedString(string: "First name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var lastNameTxtFld: UITextField = {
        var txtFld = UITextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        //                txtFld.backgroundColor = .red
        
        let placeholder = NSAttributedString(string: "Last name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        txtFld.attributedPlaceholder = placeholder
        //        txtFld.textAlignment = .center
        txtFld.textColor = .black
        txtFld.autocorrectionType = .no
        txtFld.autocapitalizationType = .none
        
        return txtFld
    }()
    
    lazy var signupBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemPink
        
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.layer.cornerRadius = 6
        btn.tintColor = .systemGray4
        btn.addTarget(self, action: #selector(signupBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var haveAccLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Already have an account?"
        //          lb.font = .boldSystemFont(ofSize: 50)
        lbl.textAlignment = .right
        lbl.textColor = .black
        //        lb.sizeToFit()
        //              lb.backgroundColor = .gray
        return lbl
    }()
    
    lazy var pickerLbl: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Add a profile photo"
        lbl.textColor = .systemPink
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var emailStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailTxtFld, separatorOne])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var firstNameStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [firstNameTxtFld, separatorTwo])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var lastNameStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [lastNameTxtFld, separatorThree])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var passwordStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [passwordTxtFld, separatorFour])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fillProportionally
        return sv
    }()
    
    lazy var signUpStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [emailStackView, firstNameStackView, lastNameStackView, passwordStackView, signupBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalSpacing
        return sv
    }()
    
    var customView = UIView()
    
    lazy var pickerStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [customView, pickerLbl])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        //        sv.addBackground(color: .brown)
        sv.distribution = .fill
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSelectedProfileIV))
        sv.isUserInteractionEnabled = true
        sv.addGestureRecognizer(tapRecognizer)
        return sv
    }()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 20)
    
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame : .zero)
        view.frame = self.view.bounds
        view.contentInsetAdjustmentBehavior = .always
        view.contentSize = contentViewSize
//        view.backgroundColor = .white
        return view
    }()
    
    lazy var scrollableContainerView : UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
//        view.backgroundColor = .yellow
        return view
    }()
    
    private var indicator: ProgressIndicator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        // Setting up activity indicator
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.clear, indicatorColor: UIColor.black, msg: "")
        indicator?.isHidden = true
        // prevents modal view to be dismissed by gesture.
        //        self.isModalInPresentation = true
        signupBtn.isEnabled = false
        
        setupView()
        handleSignupBtnUX()
        
        //            assignbackground()
        //        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "balance.jpg")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Singleton delegate
        userRegistrationViewModel.delegate = self
        
        // Remove keyboard's height observer
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        let center = NotificationCenter.default
//        center.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileImageViewPicker.roundedImage()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        self.setupToHideKeyboardOnTapOnView()
//        view.endEditing(true)
//
//    }
    
    // MARK: - Functions
    fileprivate func setupView(){
        // Costumizing Navbar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.title = "Create an account"
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = .systemPink
        
        // Adding subviews to the rootViews
        view.addSubview(scrollView)
        scrollView.addSubview(scrollableContainerView)
        [pickerStackView, signUpStackView, indicator!].forEach({scrollableContainerView.addSubview($0)})
        
        /// Auto Layout views
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        scrollableContainerView.frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width), height: self.view.frame.size.height)
        
        // setting up activity indicator
        indicator?.anchor(top: signupBtn.topAnchor, leading: view.leadingAnchor, bottom: signupBtn.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: view.frame.width/2 - 20, bottom: 0, right: view.frame.width/2 - 20))
        
        // stackview containers:
        pickerStackView.anchor(top: scrollableContainerView.topAnchor, leading: scrollableContainerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: scrollableContainerView.frame.width/2 - 75, bottom: 0, right: 0), size: CGSize.init(width: 150, height: 130))
        
        customView.addSubview(profileImageViewPicker)
        NSLayoutConstraint.activate([
            profileImageViewPicker.widthAnchor.constraint(equalToConstant: 100),
            profileImageViewPicker.heightAnchor.constraint(equalToConstant: 100),
            profileImageViewPicker.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            profileImageViewPicker.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
        ])
        
        signUpStackView.anchor(top: pickerStackView.bottomAnchor, leading: scrollableContainerView.leadingAnchor, bottom: nil, trailing: scrollableContainerView.trailingAnchor, padding: UIEdgeInsets.init(top: 10, left: 20, bottom: 0, right: 20))
        
        firstNameStackView.withHeight(45)
        lastNameStackView.withHeight(45)
        emailStackView.withHeight(45)
        passwordStackView.withHeight(45)
        separatorOne.withHeight(1)
        separatorTwo.withHeight(1)
        separatorThree.withHeight(1)
        separatorFour.withHeight(1)
        signupBtn.withHeight(45)
        
        // Handles keyboard dismissal
        self.setupToHideKeyboardOnTapOnView()
        
        // Gets Keyboard's height with an observer
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyBoardDidShow(_:)), name:  UIResponder.keyboardWillShowNotification, object: nil)
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
    
    fileprivate func validateFields() -> String? {
        // check that all fields are filled in
        if firstNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    fileprivate func handleSignupBtnUX(){
        /// Handles accessibility to the SingUp button
        firstNameTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        lastNameTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        emailTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFldDidChange), for: .editingChanged)
        
        /// Handles separator color changing
        firstNameTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        firstNameTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        lastNameTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        lastNameTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        emailTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidBegin), for: .editingDidBegin)
        passwordTxtFld.addTarget(self, action: #selector(textFldEditingDidEnd), for: .editingDidEnd)
        
    }
    
    
    // MARK: - Selectors
    @objc func keyBoardDidShow(_ notification:Notification) {
        let keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        let stackViewsHeight = (pickerStackView.frame.height + signUpStackView.frame.height + 25)
        let stackViewsFullHeight = stackViewsHeight + keyboardHeight + (navigationController?.navigationBar.frame.height)!
        let screenViewHeight = view.frame.size.height
        
        let dynamicLineUpCalcForKeyboard = (screenViewHeight - stackViewsHeight - keyboardHeight) + 10
        
        UIView.animate(withDuration: 0.3) {
            stackViewsFullHeight < screenViewHeight ? (self.scrollView.contentOffset.y = 0) : (self.scrollView.contentOffset.y = dynamicLineUpCalcForKeyboard)
        }

    }
    
    @objc fileprivate func textFldEditingDidBegin(txtFld: UITextField){
        
        if emailTxtFld.isEditing == true {
            separatorOne.backgroundColor = .systemPink
            
        } else if firstNameTxtFld.isEditing == true {
            separatorTwo.backgroundColor = .systemPink
            
        } else if lastNameTxtFld.isEditing == true {
            separatorThree.backgroundColor = .systemPink
            
        } else if passwordTxtFld.isEditing == true {
            separatorFour.backgroundColor = .systemPink
        }
        
    }
    
    @objc fileprivate func textFldEditingDidEnd(txtFld: UITextField){
        separatorOne.backgroundColor = .lightGray
        separatorTwo.backgroundColor = .lightGray
        separatorThree.backgroundColor = .lightGray
        separatorFour.backgroundColor = .lightGray
        
        UIView.animate(withDuration: 0.3) {
            /// brings back the Offset to the initial state when in a smaller screen (also for bigger screen if needed)
            self.scrollView.contentOffset.y = 0
        }
       
    }
    
    @objc fileprivate func textFldDidChange(txtFld: UITextField){
        //        txtFld.isEditing == false ? (separatorTwo.backgroundColor = .lightGray) : (separatorTwo.backgroundColor = .systemPink)
        
        guard
            let username = firstNameTxtFld.text, !username.isEmpty,
            let email = emailTxtFld.text, !email.isEmpty,
            let password = passwordTxtFld.text, !password.isEmpty
        else {
            
            self.signupBtn.setTitleColor(.systemGray4, for: .normal)
            self.signupBtn.isEnabled = false
            return
        }
        
        signupBtn.setTitleColor(.white, for: .normal)
        signupBtn.isEnabled = true
    }
    
    @objc func handleSelectedProfileIV() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
}

// MARK: - UIImagePickerControllerDelegate Extension
extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            profileImageViewPicker.image = image
            pickerLbl.text = "Great!!!"
            pickerLbl.font = .boldSystemFont(ofSize: 18)
        }
        
        print("did pick")
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Selectors
    @objc func closeViewBtnPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loginLinkPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func signupBtnPressed(){
        
        indicator?.isHidden = false
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        // validate text fields
        signupBtn.setTitle("", for: .normal)
        indicator!.start()
        
        if selectedImage == nil
        {
            print("No Selected Image")
            
            let alertController = UIAlertController(title: "Missing Profile Photo.", message: "Please choose a profile photo.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.signupBtn.setTitle("Sign Up", for: .normal)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
            self.indicator?.isHidden = true
            // presenting alertController
            alertController.view.tintColor = .systemPink
            alertController.addAction(tryAgainAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            print("An image was selected")
            
            let error = validateFields()
            
            if error != nil {
                // can also check password validation
                print("Please fill in all fields.")
                
                let alertController = UIAlertController(title: "Please fill in all fields.", message: "", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
                // enable UX
                self.indicator!.stop()
                self.signupBtn.setTitle("Sign Up", for: .normal)
                self.view.isUserInteractionEnabled = true
                self.signupBtn.isEnabled = true
                self.indicator?.isHidden = true
                // presenting alertController
                alertController.view.tintColor = .systemPink
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
                // Convert selectedImage into Data type
                guard let selectedImage = self.selectedImage?.jpegData(compressionQuality: 0.4) else { return }
                
                // Create user
                let userObject = User(id: UUID().uuidString, firstName: firstNameTxtFld.text!, lastName: firstNameTxtFld.text!, email: emailTxtFld.text!, password: passwordTxtFld.text!, numberOfFaveRecipes: 0, selectedImageUrl: selectedImage)
                // Store user in the Database
                self.userRegistrationViewModel.createUserWith(userObject)
                
            }
            
        }
        
    } // end of sign up btn func handler
    
}


// MARK: - UserRegistrationSingleton Extension
extension SignupVC: UserRegistrationSingleton {
    
    func didSignUpUser(didFetchInfo state: Bool, name: String, email: String, profileImageUrl: String, numberOfFaveRecipes: Int) {
        print("profileImageUrl: \(profileImageUrl)")
        print("fetchedName: \(name)")
        // Switch rootView in order to avoid memory leak as well as stack of views
        let mainVC = TabController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC)
    }
    
    func userRegistrationCallBack(errorMessage: String) {
        print("userRegistrationCallBack: "+errorMessage)
        var errorReader = errorMessage
        
        if errorReader == "There is no user record corresponding to this identifier. The user may have been deleted."
        {   // handles Email input error
            errorReader = "Incorrect Email"
            
            let alertController = UIAlertController(title: errorReader, message: "The email you entered doesn't appear to belong to an account. Please check your email and try again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
            // enable UX
            self.indicator!.stop()
            self.signupBtn.setTitle("Sign Up", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
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
            self.signupBtn.setTitle("Sign Up", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
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
            self.signupBtn.setTitle("Sign Up", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
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
            self.signupBtn.setTitle("Sign Up", for: .normal)
            print("Couldn't Sign Up: " + errorReader)
            self.view.isUserInteractionEnabled = true
            self.signupBtn.isEnabled = true
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
        self.signupBtn.setTitle("Sign Up", for: .normal)
        print("Couldn't Sign Up: " + errorReader)
        self.view.isUserInteractionEnabled = true
        self.signupBtn.isEnabled = true
        self.indicator?.isHidden = true
        // presenting alertController
        alertController.view.tintColor = .systemPink
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
}
