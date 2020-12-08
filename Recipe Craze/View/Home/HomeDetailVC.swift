//
//  HomeDetailVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/24/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeDetailVC: UIViewController {
        
    // MARK: - Properties
    var faveIsVisible = false
    var categIsVisible = false
    
//    var indexedIngredArray: [Ingredient] = []
    var userUID = ""
    var likedRecipeNo = 0
    
    // MARK: - ViewModel Instantiation
    var recipeViewModels = [RecipeViewModel2]()
    var categoryViewModel = [CategoryViewModel]()

    var tempIngredArray: [String] = [String]()
    var tempNutriArray: [Any] = [Any]()

    lazy var ingredientArray = recipeViewModels.first?.ingredientArray
    lazy var nutritionArray = recipeViewModels.first?.nutrientArray
    lazy var preparationSteps = recipeViewModels.first?.preparationStepsArray
    var servingsLbl = 0

    lazy var categIngredientArray = categoryViewModel.first?.ingredientArray
    lazy var categNutritionArray = categoryViewModel.first?.nutritionArray

    var ingredientfromCD: [String] = []
    var prepfromCD: [String] = []
    var nutriCDArray: [Any] = []

    
    /// CoreData Setup
    var coreDataDB = CoreDataDB(persistenceManager: PersistenceManager.shared)
    /// FirebaseDB Setup
    let ref = Database.database().reference()
    
    var recipeItemIndexPath: RecipeViewModel2? = nil
    var categItemIndexPath: CategoryViewModel? = nil

    var success = true
    
    lazy var customizedPopUp: CustomizedPopUpView = {
        let view = CustomizedPopUpView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .rgb(red: 214, green: 214, blue: 214)
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    let frameWidth: CGFloat  = 500
    let frameHeight:CGFloat  = 40.0
    
    lazy var stepperView: UIStepper = {
        let stepper = UIStepper()
        //        let stepper = UIStepper(frame: CGRect(x: (customizedPopUp.frame.width - 200)/2 , y: (customizedPopUp.frame.height - 500)/2, width: 0, height: 0))
        //        stepper.center = self.view.center
        stepper.translatesAutoresizingMaskIntoConstraints = true
        //        stepper.backgroundColor = .red
        stepper.addTarget(self, action: #selector(stepperPressed), for: .valueChanged)
        return stepper
    }()
    
    var counter = 0
    
    lazy var servingsCounterLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .black
        //        lbl.backgroundColor = .red
        lbl.text = "Servings: \(counter)"
        return lbl
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dynamicConstraint: NSLayoutConstraint!
    var viewDynamicConstraint: NSLayoutConstraint!
    var imageViewDynamicConstraint: NSLayoutConstraint!
    
    private let tableCellID = "tableCell"
    private let headerID = "headerID"
    var isRecipeSaved = false
    var isRecipeSaved2 = [Bool]()
    
    let recipeImage = UIImage(named: "food.jpg")
    let timeImage = UIImage(systemName: "clock.fill")?.withTintColor(.rgb(red: 235, green: 69, blue: 90), renderingMode: .alwaysOriginal)
    let calImage = UIImage(systemName: "flame.fill")?.withTintColor(.rgb(red: 235, green: 69, blue: 90), renderingMode: .alwaysOriginal)
    let gramImage = UIImage(named: "fat")?.withTintColor(.rgb(red: 235, green: 69, blue: 90), renderingMode: .alwaysOriginal)
    let moreIconAsset = UIImage(systemName: "ellipsis.circle.fill")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
    
    let imageSaved = UIImage(systemName: "heart.fill")
    let imageUnsaved = UIImage(systemName: "heart")
    
    lazy var recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //        iv.sizeToFit()
        //        iv.backgroundColor = .lightGray
        //        iv.image = recipeImage
        return iv
    }()
    
    lazy var imageConstantHeight: CGFloat = -(self.recipeImageView.frame.height/1.9)
    
    
    lazy var timeIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        //        iv.sizeToFit()
        //        iv.backgroundColor = .lightGray
        iv.image = timeImage
        return iv
    }()
    
    lazy var calIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        //        iv.sizeToFit()
        //        iv.backgroundColor = .lightGray
        iv.image = calImage
        return iv
    }()
    
    lazy var gramIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        //        iv.sizeToFit()
        //        iv.backgroundColor = .lightGray
        iv.image = gramImage
        return iv
    }()
    
    lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.isUserInteractionEnabled = true
        //        btn.clipsToBounds = true
        //        btn.contentMode = .scaleAspectFill
        btn.setTitle("more", for: .normal)
        //                iv.sizeToFit()
        //        btn.backgroundColor = .systemPink
        btn.tintColor = .systemPink
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .thin, scale: .small)
        btn.setImage(UIImage(systemName: "ellipsis.circle.fill")?.withConfiguration(imageConfig), for: .normal)
        btn.addTarget(self, action: #selector(moreBtnPressed), for: .touchUpInside)
        btn.centerImageAndButton(0, imageOnTop: true)
        return btn
    }()
    
    lazy var recipeNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = "Sensational Salad"
        lbl.numberOfLines = 0 // 0 = as many lines as the label needs
        lbl.frame.origin.x = 32
        lbl.frame.origin.y = 32
        lbl.font = .boldSystemFont(ofSize: 50)
        //        lbl.frame.size.width = view.frame.size.width //view.frame.size.width - 64
        lbl.textAlignment = .center
        //        lbl.backgroundColor = .systemPink
        lbl.textColor = .white
        
        return lbl
    }()
    
    lazy var durationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "duration"
        lbl.textColor = .white
        lbl.textAlignment = .center
        //        lbl.backgroundColor = .systemPink
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 10
        return lbl
    }()
    lazy var calLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "calorie"
        lbl.layer.shadowColor = .init(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Ingredients"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textColor = .white
        lbl.textAlignment = .center
        //        lbl.backgroundColor = .gray
        return lbl
    }()
    
    let ingredientArray2 = ["3 pounds riblets (pork)", "2 cups brown sugar (lightly packed)", "2 teaspoons dry mustard", "1 tablespoon chili powder", "1/4 cup Worcestershire sauce", "1/2 cup white vinegar", "1 1/2 cups ketchup", "1 cup water", "1/4 teaspoon salt", "1/2 teaspoon ground black pepper", "1/2 cup white vinegar", "1 1/2 cups ketchup", "1 cup water", "1/4 teaspoon salt", "1/2 teaspoon ground black pepper", "1/2 cup white vinegar", "1 1/2 cups ketchup", "1 cup water", "1/4 teaspoon salt", "1/2 teaspoon ground black pepper", "1/2 cup white vinegar", "1 1/2 cups ketchup", "1 cup water", "1/4 teaspoon salt", "1/2 teaspoon ground black pepper"]
    
    lazy var textView: UITextView = {
        let lbl = UITextView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "3 pounds riblets (pork) \n 2 cups brown sugar (lightly packed) \n 2 tablespoons paprika \n 2 teaspoons dry mustard \n 1 tablespoon chili powder \n 1/4 cup Worcestershire sauce \n 1/2 cup white vinegar \n 1 1/2 cups ketchup \n 1 cup water \n 1/4 teaspoon salt \n 1/2 teaspoon ground black pepper"
        lbl.textColor = .white
        //        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.font = lbl.font?.withSize(16)
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var fatsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "fats"
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var moreIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        //        iv.sizeToFit()
        //        iv.backgroundColor = .lightGray
        iv.image = moreIconAsset
        return iv
    }()
    
    lazy var moreLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "more"
        lbl.layer.shadowColor = .init(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    lazy var viewDetailsBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View Details", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 18
        btn.layer.borderColor = .init(srgbRed: 235/255, green: 69/255, blue: 90/255, alpha: 1)
        btn.layer.borderWidth = 1.5
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(viewDetailsPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var stackViewMain: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [recipeNameLabel, stackView2])
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .equalCentering
        sv.alignment = .center
        //        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var stackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [durationVStack, calVStack, gramVStack, moreBtn])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.customize(backgroundColor: UIColor.black.withAlphaComponent(0.5), radiusSize: 8)
        return sv
    }()
    
    lazy var moreBtnVStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [moreLabel])
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .equalCentering
        sv.alignment = .center
        
        //        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(moreBtnPressed))
        //        sv.isUserInteractionEnabled = false
        //        sv.addGestureRecognizer(tapRecognizer)
        //        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var durationVStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [timeIcon, durationLabel])
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .equalCentering
        sv.alignment = .center
        //        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var calVStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [calIcon, calLabel])
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .equalCentering
        sv.alignment = .center
        //        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var gramVStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [gramIcon, fatsLabel])
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .equalCentering
        sv.alignment = .center
        //        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var transparentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var centerHandlerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor =  .rgb(red: 235, green: 69, blue: 90)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var heartBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.clipsToBounds = true
        btn.tintColor = .systemPink
        btn.addTarget(self, action: #selector(heartPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var mainSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Ingredients", "Directions"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .clear
        sc.backgroundColor = .clear
        //        sc.removeBorders()
        sc.layer.borderWidth = 0
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        //        sc.sizeToFit()
        sc.selectedSegmentTintColor = .systemPink
        sc.selectedSegmentIndex = 0
        //        sc.addTarget(self, action: #selector(handleSegnmentDidChange), for: .valueChanged)
        return sc
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        //        tv.separatorColor = .gray
        tv.isScrollEnabled = true
        //        tv.isUserInteractionEnabled = false
        tv.allowsSelection = false
        tv.tableFooterView = UIView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(IngreAndDirectTV.self, forCellReuseIdentifier: tableCellID)
        tv.register(TableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerID)
        return tv
    }()
    
    var recipeID = ""
    var recipeSourceUrl = ""

    // MARK: - init
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "backgroundAppearance")  //rgb(red: 252,green: 40,blue: 71)
        //        view.backgroundColor = UIColor.init(red: 252/255, green: 40/255, blue: 71/255, alpha: 0.9)
        setupViews()
        handleSwipe()
        setupNavBar()
        tableView.separatorColor = UIColor.clear
    }
    
    var indexPathHomeVC: IndexPath = []
    var buttonStatesHomeVC = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Checks which ViewController is pushing the data 
        if categIsVisible != false {
            categIngredientArray?.forEach({ (ingreArray) in
                tempIngredArray.append(contentsOf: [ingreArray.ingredient])
            })
            
        } else {
            ingredientArray?.forEach({ (ingreArray) in
                tempIngredArray.append(contentsOf: [ingreArray.ingredient])
            })
        }

        self.setupNavBar()
        self.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let nav = navigationController?.navigationBar else { return }
        nav.titleTextAttributes = [.foregroundColor: UIColor(named: "labelAppearance")!]
        //change statusBarStyle to dark
        nav.barStyle = .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.estimatedRowHeight = 24
        tableView.rowHeight = UITableView.automaticDimension
        //        self.tableView.rowHeight = 24
        //        self.moreBtn.layer.cornerRadius = self.moreBtn.frame.size.height/2
    }
    
    // MARK: - Methods
    func storeUserDefaults(){
        //        viewModel.defaults.set(buttonStatesHomeVC, forKey: Keys.hearted)
        //        viewModel.defaults.synchronize()
    }
    
    func fetchData(){
        //        if let stateArray = viewModel.defaults.value(forKey: Keys.hearted) {
        //            let persistedStates : [Bool] = stateArray as! [Bool]
        //            print("persistedStates: \(persistedStates)")
        ////            if persistedStates[indexPathHomeVC.item] {
        ////                //on
        ////                heartBtn.setImage(imageSaved, for: .normal)
        ////                buttonStatesHomeVC[indexPathHomeVC.item] = true
        ////            } else {
        ////                //off
        ////                heartBtn.setImage(imageUnsaved, for: .normal)
        ////                buttonStatesHomeVC[indexPathHomeVC.item] = false
        ////            }
        //        }
        
        //        let post = viewModel.recipePostArray[indexPathHomeVC.item]
        ref.child("users/\(userUID)/favoritedRecipes/recipeID: \(recipeID)/name").observeSingleEvent(of: .value) { (snapshot) in
            let name = snapshot.value as? String
            if name == self.recipeNameLabel.text! {
                self.heartBtn.setImage(self.imageSaved, for: .normal)
            } else {
                self.heartBtn.setImage(self.imageUnsaved, for: .normal)
            }
//            print("Name: \(String(describing: name))")
        }
    }
    
    fileprivate func setupNavBar(){
        //        backButton.title = ""
        let backButton = UIBarButtonItem()
        
        guard let nav = navigationController?.navigationBar else { return }
        nav.prefersLargeTitles = false
        //change statusBarStyle to light
        nav.barStyle = .black
        //        nav.setBackgroundImage(UIImage(), for: .default)
        //        navigationItem.largeTitleDisplayMode = .automatic
        nav.topItem?.backBarButtonItem = backButton
        nav.topItem?.backBarButtonItem?.tintColor = .systemPink
        nav.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        nav.setBackgroundImage(UIImage(), for: .default)
        nav.hideNavBarSeperator()
        //        nav.isTranslucent = true
        
//        title = "Quick and Easy".uppercased()
        
        let customRightBtn = UIBarButtonItem(customView: heartBtn)
        navigationItem.rightBarButtonItem =  customRightBtn
        
        //        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "heart")?.withTintColor(.rgb(red: 235, green: 69, blue: 90), renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(heartPressed)), animated: true)
    }
    
    fileprivate func setupViews(){
        [tableView, recipeImageView, transparentView, visualEffectView].forEach({view.addSubview($0)})
        [stackViewMain, viewDetailsBtn, centerHandlerView].forEach({transparentView.addSubview($0)})
        //        titleLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: tableView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        tableView.anchor(top: recipeImageView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        recipeImageView.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        // setup dynamic constraint
        self.imageViewDynamicConstraint = self.recipeImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        self.imageViewDynamicConstraint.isActive = true
        
        transparentView.anchor(top: recipeImageView.topAnchor, leading: recipeImageView.leadingAnchor, bottom: recipeImageView.bottomAnchor, trailing: recipeImageView.trailingAnchor)
        
        
        //        stackViewMain.withHeight(200)
        stackViewMain.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        // setup dynamic constraint
        self.dynamicConstraint = self.stackViewMain.bottomAnchor.constraint(equalTo: viewDetailsBtn.safeAreaLayoutGuide.topAnchor, constant: -15)
        self.dynamicConstraint.isActive = true
        
        //        recipeNameLabel.withHeight(50)
        recipeNameLabel.withWidth(view.frame.width - 50)
        stackView2.withHeight(50)
        stackView2.withWidth(view.frame.width/1.4)
        
        //        moreBtn.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: 50, right: 0), size: CGSize(width: 50, height: 50))
        moreBtn.isHidden = true
        
        viewDetailsBtn.withHeight(36)
        viewDetailsBtn.withWidth(180)
        viewDetailsBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewDetailsBtn.bottomAnchor.constraint(equalTo: recipeImageView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        centerHandlerView.isHidden = true
        centerHandlerView.centerXAnchor.constraint(equalTo: transparentView.centerXAnchor).isActive = true
        centerHandlerView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -8).isActive = true
        centerHandlerView.withHeight(5)
        centerHandlerView.withWidth(50)
        
        
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.alpha = 0
        
        //        stackViewMain.fadeOut()
        //        stackViewMain.fadeIn()
        //        viewDetailsBtn.fadeOut()
        //        viewDetailsBtn.fadeIn()
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //            UIView.transition(with: self.transparentView,
        //            duration: 0.3,
        //            options: [.allowAnimatedContent, .transitionCrossDissolve],
        //            animations: {
        //                self.transparentView = self.stackViewMain
        //            },
        //            completion: nil)
        //        }
        
    }
    
    func handleSwipe(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        transparentView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func handleShowPopUp() {
        view.addSubview(customizedPopUp)
        [stepperView, servingsCounterLbl].forEach({customizedPopUp.addSubview($0)})
        
        customizedPopUp.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        customizedPopUp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customizedPopUp.heightAnchor.constraint(equalToConstant: view.frame.width/1.8).isActive = true
        customizedPopUp.widthAnchor.constraint(equalToConstant: view.frame.width/1.5).isActive = true
        
        stepperView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        stepperView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stepperView.withHeight(stepperView.frame.height)
        stepperView.withWidth(stepperView.frame.width)
        
        servingsCounterLbl.anchor(top: nil, leading: customizedPopUp.leadingAnchor, bottom: stepperView.topAnchor, trailing: customizedPopUp.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        
        customizedPopUp.showSuccessMessage = success
        success = !success
        
        customizedPopUp.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        customizedPopUp.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 0.4
            self.customizedPopUp.alpha = 1
            self.customizedPopUp.transform = CGAffineTransform.identity
        }
        
        //        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Selectors
    @objc func stepperPressed(_ sender: UIStepper) {
        counter = Int(sender.value)
        servingsCounterLbl.text = "Servings: \(counter)"
        //        print(counter)
        //        counter += 1
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        //        print("afterHeight handlePanGesture: \(imageConstantHeight))")
        let velocity : CGPoint = gesture.velocity(in: transparentView)
        let translation = gesture.translation(in: self.view)
        
        guard let centerY = gesture.view?.center.y else { return }
        if gesture.state == .began || gesture.state == .changed {
            
            var tempConstant: CGFloat = 0
            if UIScreen.main.bounds.height <= 667 {
                tempConstant = -325
            } else {
                tempConstant = -401
            }
            
            // Dragging view (move view downward) 192 407
            if self.imageViewDynamicConstraint.constant < 0 && self.imageViewDynamicConstraint.constant >= tempConstant {
                //                recipeImageView.center.y += translation.y
                self.imageViewDynamicConstraint.constant += translation.y
                //                gesture.setTranslation(.zero, in: view)
//                print("Dragging: \(centerY) imageConstant: \(self.imageViewDynamicConstraint.constant)")
            } else {
                // move view upward with limitation && centerY > 321 small = 308 big =341
                /// Check device size (iPhone SE 2ng Gen)
                if UIScreen.main.bounds.height <= 667 {
                    if centerY > 138 && self.imageViewDynamicConstraint.constant < 0 {
                        //                        recipeImageView.center.y -= -translation.y
                        self.imageViewDynamicConstraint.constant -= -translation.y
                        //                        tableView.center.y -= -translation.y
                                                print("translation: \(translation.y) centerY:\(centerY) velocity:\(velocity.y)")
                        gesture.setTranslation(.zero, in: view)
                    } else {
//                        print("centerY limit1: \(centerY)")
                        if centerY >= 145 {
                        self.moreBtn.isHidden = true
                        }
                    }
                } else {
                    
                    if centerY >= 190 && self.imageViewDynamicConstraint.constant < 0 {
                        //                        recipeImageView.center.y -= -translation.y
                        self.imageViewDynamicConstraint.constant -= -translation.y
//                        print("centerY: \(centerY)")
//                        print("translation: \(translation.y) centerY:\(centerY) velocity:\(velocity.y) imageDynamicConstraint: \(self.imageViewDynamicConstraint.constant) imageConstantHeight: \(imageConstantHeight) imageHeight: \(recipeImageView.frame.height)")
                        
                        gesture.setTranslation(.zero, in: view)
                    } else {
                        //                        self.imageViewDynamicConstraint.constant -= -translation.y
//                        print("Inner If")
//                        print("centerY limit2: \(centerY)")
                        if centerY >= 195 {
                        self.moreBtn.isHidden = true
                        }
                    }
                }
                
            } // End of Dragging view
            gesture.setTranslation(.zero, in: view)
            
        } else if gesture.state == .ended {
            // View snaps back to top
            if centerY <= 215  { //&& centerY <= 163
//                print("Animation ended")
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveLinear, animations: {
                    //                    self.recipeImageView.frame.origin.y = -(self.recipeImageView.frame.height/1.9)
                    self.imageViewDynamicConstraint.constant = self.imageConstantHeight
                }, completion: nil)
                
            } else {
                // View goes down automatically
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    
                    self.imageViewDynamicConstraint.constant = 0
                    
                    UIView.animate(withDuration: 0.5) {
                        self.dynamicConstraint.constant = -15
                        //self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                    }
                    
                    gesture.setTranslation(.zero, in: self.view)
                    
                    self.centerHandlerView.isHidden = true
                    self.moreBtn.fadeOut()
                    self.moreBtn.isHidden = true
                    
                    //  self.transparentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                    //  self.recipeImageView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
                    
                    UIView.transition(with: self.recipeNameLabel, duration: 0.5, options: .curveEaseInOut, animations: { [self] in
                        recipeNameLabel.font = .boldSystemFont(ofSize: 50)
                    }) { isFinished in }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.viewDetailsBtn.isHidden = false
                    }
                }, completion: nil)
                
            }
        }
        
        
    }
    
    @objc func viewDetailsPressed(_ sender: UIButton){
        print("viewDetails Pressed")
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 2.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            //            self.recipeImageView.frame.origin.y = -(self.recipeImageView.frame.height/1.9)
            
            // Handles more button availability
            //            self.moreBtnVStack.isUserInteractionEnabled = true
            self.moreIcon.image = self.moreIconAsset?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
            self.moreLabel.textColor = .white
            
            UIView.animate(withDuration: 0.5) { [self] in
                self.dynamicConstraint.constant = 25
                self.imageViewDynamicConstraint.constant = self.imageConstantHeight

                if UIScreen.main.bounds.height <= 667 {
                    UIView.transition(with: recipeNameLabel, duration: 2.8, options: .curveEaseInOut, animations: {
                        recipeNameLabel.font = .boldSystemFont(ofSize: 30)
                    }) { isFinished in }
                    
                } else {
                    UIView.transition(with: recipeNameLabel, duration: 2.8, options: .curveEaseInOut, animations: {
                        recipeNameLabel.font = .boldSystemFont(ofSize: 40)
                    }) { isFinished in }
                }
                
//                print("imageViewDynamicConstraint: \(self.imageViewDynamicConstraint.constant)")

                //                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            
            self.viewDetailsBtn.isHidden = true
            self.moreBtn.fadeIn()
            self.moreBtn.isHidden = false
            
            //            self.transparentView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
            //            self.recipeImageView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
            //            self.textView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.centerHandlerView.isHidden = false
            }
        }, completion: nil)
    }
    
    @objc func heartPressed(_ sender: UIButton){
//        print("indexPathHomeVC: \(indexPathHomeVC)")
        buttonStatesHomeVC[indexPathHomeVC.item] = !buttonStatesHomeVC[indexPathHomeVC.item]
//        : try JSONEncoder().encode(recipeItemIndexPath)
        var dynamicDic: [String: Any] = [:]
        
        if categIsVisible == true {
            guard let categDict = try! JSONSerialization.jsonObject(with: try JSONEncoder().encode(categItemIndexPath) , options: []) as? [String: Any] else {return}
            
            dynamicDic = categDict
            if let nutriArray = dynamicDic["nutritionArray"] {
                nutriCDArray.append(nutriArray)
            }
        } else {
            guard let homeDict = try! JSONSerialization.jsonObject(with: try JSONEncoder().encode(recipeItemIndexPath) , options: []) as? [String: Any] else {return}
            dynamicDic = homeDict
            if let nutriArray = dynamicDic["nutrientArray"] {
                nutriCDArray.append(nutriArray)
            }
        }
//        if let nutriArray = categIsVisible ? (dict["nutritionArray"]) : (dict["nutrientArray"]) {
//            nutriCDArray.append(nutriArray)
//        }
        
//        print("nutritionArrayCD: \(nutriCDArray)")
        
//        var tempIngredArray: [String] = []
//        let temp = ingredientArray ?? []
//        temp.forEach { (list) in
//            tempIngredArray.append(list.ingredient)
//        }
        
        if buttonStatesHomeVC[indexPathHomeVC.item] {
            //on
            let newRef = ref.child("users/\(userUID)/favoritedRecipes").child("recipeID: \(recipeID)")
            newRef.updateChildValues(dynamicDic)
            
            likedRecipeNo += 1
            let newRef2 = self.ref.child("users/\(userUID)")
            newRef2.updateChildValues(["numberOfFaveRecipes": likedRecipeNo])
            
            coreDataDB.checkIfItemExist(id: recipeID, name: recipeNameLabel.text!, image: recipeImageView.image, ingredArray: tempIngredArray, duration: durationLabel.text!, servingsNo: Int32(servingsLbl), prepArray: self.preparationSteps, nutriArray: nutriCDArray, sourceUrl: recipeSourceUrl)
            sender.setImage(imageSaved, for: .normal)
            buttonStatesHomeVC[indexPathHomeVC.item] = true
        } else {
            //off
            ref.child("users/\(userUID)/favoritedRecipes/recipeID: \(recipeID)").removeValue()
            
            likedRecipeNo -= 1
            let newRef2 = self.ref.child("users/\(userUID)")
            newRef2.updateChildValues(["numberOfFaveRecipes": likedRecipeNo])
            
            coreDataDB.deleteItem(name: recipeNameLabel.text!)
            sender.setImage(imageUnsaved, for: .normal)
            buttonStatesHomeVC[indexPathHomeVC.item] = false
        }
        
        Vibration.light.vibrate()
        
        //        print("buttonStatesHomeVC: \(buttonStatesHomeVC)")
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
                       }, completion: { (Bool) in
                        self.storeUserDefaults()
                       })
        
        
        //        favoritedVM.storeUserDefaultsData()
        //        isRecipeSaved = !isRecipeSaved
        //
        //        if isRecipeSaved {
        //            //on
        //            sender.setImage(imageSaved, for: .normal)
        ////            indexPathHomeVC = true
        //        } else {
        //            //off
        //            sender.setImage(imageUnsaved, for: .normal)
        ////            indexPathHomeVC = false
        //        }
        
        //        isRecipeSaved = !isRecipeSaved
        //
        //        if !isRecipeSaved{
        //            sender.setImage(imageUnsaved, for: .normal)
        ////            favoritedVM.deleteItem(name: recipePostArray[tappedIndexPath.item].name)
        //            print(isRecipeSaved)
        //        } else {
        //            sender.setImage(imageSaved, for: .normal)
        ////            favoritedVM.checkIfItemExist(name: recipePostArray[tappedIndexPath.item].name)
        //            print(isRecipeSaved)
        //        }
    }
    
    @objc fileprivate func handleSegnmentDidChange(_ sender: UISegmentedControl){
        tableView.reloadData()
    }
    
    @objc fileprivate func moreBtnPressed() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .systemPink
        let cookNowAction = UIAlertAction(title: "Cook Now", style: .default) { [self] cook in
            print("cook now")
            
            let onScreenStepsVC = OnScreenStepsVC()
            onScreenStepsVC.foodNameLbl.text = self.recipeNameLabel.text
            onScreenStepsVC.servingsLbl.text = "Servings: \(servingsLbl)"
            /// Pass preparationStepsArray data through ViewModel to OnScreenStepsVC
            onScreenStepsVC.preparationStepsArray =  /*faveIsVisible == true ? prepfromCD : self.preparationSteps*/self.preparationSteps
            onScreenStepsVC.modalPresentationStyle = .fullScreen
            self.present(onScreenStepsVC, animated: true)
        }
        
        let nutrientInfo = UIAlertAction(title: "Nutrition Facts", style: .default) { [self] _ in
            let foodInfoVC = FoodInfoVC()
            let foodInfoVCWithNavBar = UINavigationController(rootViewController: foodInfoVC)
            let modifiedLbl = recipeNameLabel
            modifiedLbl.numberOfLines = 0
            foodInfoVC.title = modifiedLbl.text
            /// Pass nutritionArray data through ViewModel to FoodInfoVC
            foodInfoVC.nutritionArray = nutritionArray
            foodInfoVC.categNutritionArray = categNutritionArray

            // Let the foodInfoVC know that this data is coming from FavoriteVC/CategoryVC by checking the visibility of FavoriteVC
            foodInfoVC.faveIsVisible = faveIsVisible
            foodInfoVC.categIsVisible = categIsVisible
            foodInfoVC.nutriCDArray = faveIsVisible == true || categIsVisible == true ? nutriCDArray : [] // avoid indexPath error
            self.present(foodInfoVCWithNavBar, animated: true)
        }
        
        //        let changeServings = UIAlertAction(title: "Change Servings", style: .default) { _ in
        //            print("change servings")
        //            self.handleShowPopUp()
        //        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        /// Check if arrays are empty in order to disable action buttons for better UX 
        self.preparationSteps?.isEmpty == true ? (cookNowAction.isEnabled = false) : (cookNowAction.isEnabled = true)
        self.nutritionArray?.isEmpty == true ? (nutrientInfo.isEnabled = false) : (nutrientInfo.isEnabled = true)
        
        actionSheet.addAction(cookNowAction)
        actionSheet.addAction(nutrientInfo)
        //        actionSheet.addAction(changeServings)
        actionSheet.addAction(cancelAction)
        actionSheet.fixActionSheetConstraintsError()
        present(actionSheet, animated: true)
    }
    
    
}


extension HomeDetailVC: TableViewDataSourceAndDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return faveIsVisible == true ? ingredientfromCD.count : tempIngredArray.count
//            /*ingredientArray?.isEmpty == true ? ingredientArray?.count ?? 0 : ingredientfromCD.count*/ ingredientArray?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath) as! IngreAndDirectTV
//        let indexAt = ingredientArray![indexPath.row]
//        let indexAt2 = ingredientfromCD[indexPath.row]
        //        if UIScreen.main.bounds.height <= 667 {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        //        } else {
        //            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (tableView.bounds.height/2.5 - cell.bounds.height/2.5), right: 0)
        //        }

//        if faveIsVisible != false {
//            print("Array is nil")
//        } else {
//            print("PrintIngredientArray: \(String(describing: ingredientArray?.count))")
//        }
        
        titleLabel.text = "Ingredients"
        cell.textLabel?.textColor = UIColor(named: "labelAppearance")
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = faveIsVisible == true ? ingredientfromCD[indexPath.row] : tempIngredArray[indexPath.row] //.ingredient
//            /*ingredientArray?.isEmpty == true ?*/ ingredientArray![indexPath.row].ingredient //: ingredientfromCD[indexPath.row] //indexAt.ingredient
        
        cell.backgroundColor = .clear
        //            cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        let customView = UIView()
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! TableViewHeader
        TableViewHeader.appearance().forceBackgroundColor = UIColor(named: "backgroundAppearance")
        headerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor(named: "labelAppearance")
        titleLabel.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
}

// MARK: - FoodInfoVC Extension of CustomizedPoUpView
extension HomeDetailVC: CustomizedPopUpViewDelegate {
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.customizedPopUp.alpha = 0
            self.customizedPopUp.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.customizedPopUp.removeFromSuperview()
            print("Did remove pop up window..")
        }
    }
    
    
}


