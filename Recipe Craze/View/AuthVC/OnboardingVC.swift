//
//  OnboardingVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/18/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FirebaseAuth
import FirebaseDatabase

class OnboardingVC: UIViewController {
    
    // MARK: - Properties
    var btnsSize: CGFloat = 40
    var onBoardingImages = ["Online_groceries", "Breakfast2", "Chef"]
    var onBoardingTitle = ["Easy Browsing", "Quick Recipes", "You're the Chef"]
    var onBoardingDescrip = ["Increase the range of job opportunity for self-employed technicians.",
                             "Increase the range of job opportunity for self-employed technicians.",
                             "Increase the range of job opportunity for self-employed technicians."]
    
    lazy var signInWithAppleBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.frame = CGRect(x: 0, y: 0, width: 0, height: btnsSize)
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        
        btn.backgroundColor = .black
        btn.setImage(UIImage(systemName: "applelogo"), for: .normal)
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 2, right: 0)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(signUpWithAppleBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var signInWithGoogleBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.frame = CGRect(x: 0, y: 0, width: 0, height: btnsSize)
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        
        let image = UIImage(named: "google")
        btn.setImage(image?.imageResized(to: CGSize(width: 26, height: 26)), for: .normal)
        btn.imageEdgeInsets = .init(top: 1, left: 0, bottom: 0, right: 0)
        btn.backgroundColor = .white
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(signUpWithGoogleBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var signInWithFacebookBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.frame = CGRect(x: 0, y: 0, width: 0, height: btnsSize)
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        
        btn.backgroundColor = UIColor.rgb(red: 69, green: 152, blue: 223)
        let image = UIImage(named: "facebook")?.withRenderingMode(.alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 3, right: 2)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(signUpWithFacebookBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var signUpWithEmailBtn: UIButton = {
        var btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemPink
        
        btn.setTitle("Sign up with Email", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(signUpWithEmailBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var signUpStackView: UIStackView = {
        var sv = UIStackView(arrangedSubviews: [signUpWithEmailBtn, signInWithAppleBtn, signInWithFacebookBtn, signInWithGoogleBtn])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 15
        sv.distribution = .fillProportionally
        //        sv.addBackground(color: .cyan)
        return sv
    }()
    
    var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundTopLeftAndRightCorners(radius: 30)
        view.backgroundColor = .systemGray3
        
        return view
    }()
        
    lazy var onboardingStackView: UIStackView = {
        var iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: onBoardingImages[0])
//        iv.backgroundColor = .black
        iv.withHeight(view.frame.width/1.18)

        var lbl = UILabel()
        lbl.text = onBoardingTitle[0]
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 33)
        lbl.textAlignment = .center
//        lbl.backgroundColor = .green
        
        var lbl2 = UILabel()
        lbl2.text = onBoardingDescrip[0]
        lbl2.numberOfLines = 0
//        lbl2.font = .boldSystemFont(ofSize: 25)
        lbl2.textAlignment = .center
//        lbl2.backgroundColor = .green
        
        let lowerView = UIView()
        self.view.addSubview(lowerView)
        [lbl, lbl2].forEach {lowerView.addSubview($0)}
        
        lbl.anchor(top: lowerView.topAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: view.frame.width/12, bottom: 0, right: view.frame.width/12))
        
        lbl2.anchor(top: lbl.bottomAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: view.frame.width/17, bottom: 0, right: view.frame.width/17))

        var sv = UIStackView(arrangedSubviews: [iv, lowerView])
        sv.axis = .vertical
//        sv.spacing = 15
        sv.distribution = .fill
//        sv.addBackground(color: .cyan)
        return sv
    }()
    
    lazy var onboardingStackView2: UIStackView = {
        var iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: onBoardingImages[1])
//        iv.backgroundColor = .black
        iv.withHeight(view.frame.width/1.18)

        var lbl = UILabel()
        lbl.text = onBoardingTitle[1]
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 33)
        lbl.textAlignment = .center
//        lbl.backgroundColor = .green
        
        var lbl2 = UILabel()
        lbl2.text = onBoardingDescrip[1]
        lbl2.numberOfLines = 0
//        lbl2.font = .boldSystemFont(ofSize: 25)
        lbl2.textAlignment = .center
//        lbl2.backgroundColor = .green
        
        let lowerView = UIView()
        self.view.addSubview(lowerView)
        [lbl, lbl2].forEach {lowerView.addSubview($0)}
        
        lbl.anchor(top: lowerView.topAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: view.frame.width/12, bottom: 0, right: view.frame.width/12))
        
        lbl2.anchor(top: lbl.bottomAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: view.frame.width/17, bottom: 0, right: view.frame.width/17))

        var sv = UIStackView(arrangedSubviews: [iv, lowerView])
        sv.axis = .vertical
        sv.spacing = 15
        sv.distribution = .fill
        //        sv.addBackground(color: .cyan)
        return sv
    }()
    
    lazy var onboardingStackView3: UIStackView = {
        var iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: onBoardingImages[2])
//        iv.backgroundColor = .black
        iv.withHeight(view.frame.width/1.18)

        var lbl = UILabel()
        lbl.text = onBoardingTitle[2]
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 33)
        lbl.textAlignment = .center
//        lbl.backgroundColor = .green
        
        var lbl2 = UILabel()
        lbl2.text = onBoardingDescrip[2]
        lbl2.numberOfLines = 0
//        lbl2.font = .boldSystemFont(ofSize: 25)
        lbl2.textAlignment = .center
//        lbl2.backgroundColor = .green
        
        let lowerView = UIView()
        self.view.addSubview(lowerView)
        [lbl, lbl2].forEach {lowerView.addSubview($0)}
        
        lbl.anchor(top: lowerView.topAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: view.frame.width/12, bottom: 0, right: view.frame.width/12))
        
        lbl2.anchor(top: lbl.bottomAnchor, leading: lowerView.leadingAnchor, bottom: nil, trailing: lowerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: view.frame.width/17, bottom: 0, right: view.frame.width/17))

        var sv = UIStackView(arrangedSubviews: [iv, lowerView])
        sv.axis = .vertical
        sv.spacing = 15
        sv.distribution = .fill
        //        sv.addBackground(color: .cyan)
        return sv
    }()
    
    lazy var views = [onboardingStackView, onboardingStackView2, onboardingStackView3]
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.width)
        
        for i in 0..<onBoardingImages.count {
            scrollView.addSubview(views[i])
            
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height/1.4)
        }
        
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemPink
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        return pageControl
    }()
    
    lazy var loginBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action:  #selector(signInNavBarBtn))
        btn.tintColor = .systemPink
        return btn

    }()
    
    let loginManager = LoginManager()
    var biggerIndicator: ProgressIndicatorLarge!
    
    lazy var indicatorLayerTransparentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.isHidden = true
        
        biggerIndicator = ProgressIndicatorLarge(inview: self.view, loadingViewColor: UIColor.clear, indicatorColor: UIColor.black, msg: "")
        biggerIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(biggerIndicator!)
        
        NSLayoutConstraint.activate([
            biggerIndicator!.widthAnchor.constraint(equalToConstant: 20),
            biggerIndicator!.heightAnchor.constraint(equalToConstant: 50),
            biggerIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            biggerIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        return view
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupView()
        setupOnboarding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        removeLoadingScreen()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - SetupView
    func setupView() {
        [customView, indicatorLayerTransparentView].forEach {view.addSubview($0)}
        [signUpStackView].forEach {customView.addSubview($0)}
        
        indicatorLayerTransparentView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 0))
        
        var customViewDynamicHeight: CGFloat = 0
        var svDynamicPadding: CGFloat = 0
        view.bounds.height <= 667 ? (customViewDynamicHeight = 100) : (customViewDynamicHeight = view.frame.width/2.8)
        view.bounds.height <= 667 ? (svDynamicPadding = (customViewDynamicHeight - btnsSize)/2) : (svDynamicPadding = (view.frame.width - btnsSize)/5.6)

        customView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: customViewDynamicHeight))
        
        layoutBtnsCornerRadius()
        
        signUpStackView.anchor(top: nil, leading: customView.leadingAnchor, bottom: customView.bottomAnchor, trailing: customView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: svDynamicPadding, right: 15), size: CGSize(width: 0, height: btnsSize))
        
//        onboardingView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: customView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 44, left: 0, bottom: -15, right: 0))
        
        setNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSignInWithGoogleObserver), name: NSNotification.Name("SuccessfulSignInNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(progressIndicatorStartObserver), name: NSNotification.Name("ProgressIndicatorDidStartNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(progressIndicatorStopObserver), name: NSNotification.Name("ProgressIndicatorDidStopNotification"), object: nil)
        
    }
    
    // MARK: - Methods
    func addLoadingScreen() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: { [self] in
            indicatorLayerTransparentView.isHidden = false
            view.isUserInteractionEnabled = false
            loginBtn.isEnabled = false
            loginBtn.tintColor = .systemGray4
            indicatorLayerTransparentView.layer.zPosition = 5
            biggerIndicator?.start()
        }, completion: nil)
    }
    
    func removeLoadingScreen() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: { [self] in
            indicatorLayerTransparentView.isHidden = true
            view.isUserInteractionEnabled = true
            loginBtn.isEnabled = true
            loginBtn.tintColor = .systemPink
            indicatorLayerTransparentView.layer.zPosition = -5
            biggerIndicator.stop()
        }, completion: nil)
    }
    
    func signInWithGoogle() {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            print("signed in")
        } else {
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        }
       
    }
    
    func firebaseFaceBookLogin() {
        
        // Setup facebookLogin Manager
        let loginManager = LoginManager()
        let readPermissions: [Permission] = [ .publicProfile]
        
        loginManager.logIn(permissions: readPermissions, viewController: self) { [self] (loginResult) in
            
            switch loginResult {
            case .failed(let error):
                print("emailError: "+error.localizedDescription)
                removeLoadingScreen()
            case .cancelled:
                print("User cancelled login.")
                removeLoadingScreen()
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                addLoadingScreen()
                print("Logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        let errorMessage = error.localizedDescription
                        print("Error: " + errorMessage)
                        alertControllerErrorHandler(errorMessage: errorMessage)
                        return
                    }
                    
                    guard let userInfo = authResult?.user else { return }
                    // Allows access full details of the user facebook account
                    let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email, picture.type(large)"])
                    
                    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                        
                        if error != nil {
                            let errorMessage = error!.localizedDescription
                            print("Error: " + errorMessage)
                        } else {
                            
                            guard let userInfoDic = result as? NSDictionary else { return }
                            let data = userInfo.providerData[0]
                            let photoUrl = data.photoURL ?? URL(fileURLWithPath: "N/A")
                            let profileImageUrl = "\(photoUrl)?height=300&access_token=\(accessToken.tokenString)"
                            
                            let firstName = userInfoDic.value(forKey: "first_name") as? String ?? "Unavailable"
                            let lastName = userInfoDic.value(forKey: "last_name") as? String ?? "Unavailable"
                            let email = userInfoDic.value(forKey: "email") as? String ?? "Unavailable"
                            
                            storeUserFBDataOnFirebase(userInfo.uid, email, firstName, lastName, profileImageUrl)
                        }
                    })
                    
                    
                }
            }
        }
    }
    
    func storeUserFBDataOnFirebase(_ userID: String, _ email: String, _ firstName: String, _ lastName: String, _ profileImageUrl: String) {
        
        // Store userInfo in the Firebase DB
        let db = Database.database().reference()
        let useRef = db.child("users")
        let newUserRef = useRef.child(userID)
        newUserRef.updateChildValues(["id": userID,
                                      "firstName": firstName,
                                      "lastName": lastName,
                                      "email": email,
                                      "password": "N/A",
                                      "profileImageUrl": profileImageUrl])
        
        // SignIn observer
        NotificationCenter.default.post(name: Notification.Name("SuccessfulSignInNotification"), object: nil, userInfo: nil)
        removeLoadingScreen()
    }
    
    func signInWithApple() {
        let alertController = UIAlertController(title: "Oops!!!", message: "Sorry! I'm not part of the Apple Developer Program just yet.", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
        // presenting alertController
        alertController.view.tintColor = .systemPink
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertControllerErrorHandler(errorMessage: String) {
        removeLoadingScreen()
        let errorTitle = "Existing account"
        
        let alertController = UIAlertController(title: errorTitle, message: "An account already exists with the same email address, try sign in instead.", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in }
        // presenting alertController
        alertController.view.tintColor = .systemPink
        alertController.addAction(tryAgainAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupOnboarding() {
        [scrollView, pageControl].forEach {view.addSubview($0)}
        
        scrollView.withWidth(view.frame.width)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: customView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        pageControl.anchor(top: nil, leading: view.leadingAnchor, bottom: customView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func layoutBtnsCornerRadius() {
        signInWithAppleBtn.withWidth(btnsSize)
        signInWithFacebookBtn.withWidth(btnsSize)
        signInWithGoogleBtn.withWidth(btnsSize)
        
        signUpWithEmailBtn.layer.cornerRadius = 20
        signInWithAppleBtn.layer.cornerRadius = signInWithAppleBtn.frame.size.height/2
        signInWithFacebookBtn.layer.cornerRadius = signInWithFacebookBtn.frame.size.height/2
        signInWithGoogleBtn.layer.cornerRadius = signInWithGoogleBtn.frame.size.height/2
    }
    
    func setNavigationBar() {
        guard let nav = navigationController?.navigationBar else { return }
        nav.setBackgroundImage(UIImage(), for: .default)
        nav.hideNavBarSeperator()
        
        navigationItem.rightBarButtonItem = loginBtn
    }
    
    
    // MARK: - Selectors
    @objc func didSignInWithGoogleObserver()  {
        removeLoadingScreen()
//        biggerIndicator?.stop()
        // Switch rootView after user gets signedIn
        let mainVC = TabController()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC)
    }
    
    @objc func progressIndicatorStartObserver() {
        addLoadingScreen()
        print("start")
    }
    
    @objc func progressIndicatorStopObserver() {
        removeLoadingScreen()
        print("stop")
    }
    
    @objc private func signInNavBarBtn(){
        let signInVC = LoginVC()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @objc private func signUpWithEmailBtnPressed() {
        let signUpVC = SignupVC()
        signUpVC.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func signUpWithAppleBtnPressed() {
        signInWithApple()
    }
    
    @objc private func signUpWithFacebookBtnPressed() {
        firebaseFaceBookLogin()
    }
    
    @objc private func signUpWithGoogleBtnPressed() {
        signInWithGoogle()
    }
    
    @objc func pageControlTapHandler(sender: UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate Extension
extension OnboardingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

struct FacebookPermission
{
    static let ID: String = "id"
    static let NAME: String = "name"
    static let EMAIL: String = "email"
    static let PROFILE_PIC: String = "picture"
    static let LAST_NAME: String = "last_name"
    static let FIRST_NAME: String = "first_name"
    static let USER_FRIENDS: String = "user_friends"
    static let PUBLIC_PROFILE: String = "public_profile"
}
