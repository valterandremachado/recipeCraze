//
//  OnboardingVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/18/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

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
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
       
        setupView()
        setupOnboarding()
    }
    
    
    // MARK: - SetupView
    func setupView() {
        [customView].forEach {view.addSubview($0)}
        [signUpStackView].forEach {customView.addSubview($0)}
        
        customView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: view.frame.width/2.5))
        
        layoutBtnsCornerRadius()
        
        signUpStackView.anchor(top: nil, leading: customView.leadingAnchor, bottom: customView.bottomAnchor, trailing: customView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: (view.frame.width - btnsSize)/5, right: 15), size: CGSize(width: 0, height: btnsSize))
        
//        onboardingView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: customView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 44, left: 0, bottom: -15, right: 0))
        
        setNavigationBar()
    }
    
    // MARK: - Methods
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
    
//    lazy var loginBtn: UIBarButtonItem = {
//        let btn = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action:  #selector(signInNavBarBtn))
//        btn.tintColor = .systemPink
//        return btn
//    }()
   
    func setNavigationBar() {
//        let navItem = UINavigationItem(title: "")
        guard let nav = navigationController?.navigationBar else { return }
//        let navBar = UINavigationBar()
//        navBar.translatesAutoresizingMaskIntoConstraints = false
        nav.setBackgroundImage(UIImage(), for: .default)
        nav.hideNavBarSeperator()
        
        let loginBtn = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action:  #selector(signInNavBarBtn))
        loginBtn.tintColor = .systemPink
        
        navigationItem.rightBarButtonItem = loginBtn
//        navBar.setItems([navItem], animated: false)
        
//        self.view.addSubview(navBar)
//        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    // MARK: - Selectors
    @objc private func signInNavBarBtn(){
        let signInVC = LoginVC()
//        signInVC.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(signInVC, animated: true)
//        present(signInVC, animated: true)
    }
    
    @objc private func signUpWithEmailBtnPressed() {
        let signUpVC = SignupVC()
        signUpVC.modalPresentationStyle = .formSheet
//        present(signUpVC, animated: true)
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func signUpWithAppleBtnPressed() {
        //        let signUpVC = SignupVC()
        //        navigationController.pushViewController(navigationController, animated: true)
    }
    
    @objc private func signUpWithFacebookBtnPressed() {
        //        let signUpVC = SignupVC()
        //        navigationController.pushViewController(navigationController, animated: true)
    }
    
    @objc private func signUpWithGoogleBtnPressed() {
        //        let signUpVC = SignupVC()
        //        navigationController.pushViewController(navigationController, animated: true)
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

