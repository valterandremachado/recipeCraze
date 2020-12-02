//
//  HomeVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import LBTATools
import CoreData
import UserNotifications
import FirebaseDatabase
import FirebaseAuth
import ShimmerSwift

let notificationID = "notificationID"

class HomeVC: UIViewController, HomeVCDelegate {
    
    let tempArray = ["1", "2"]
    var savedRecipes = [FavoritedRecipeToCD]()
    
    // UserAuthViewModel
    var userAuthViewModel = UserAuthViewModel.shared
    
    /// FirebaseDB setup
    let ref = Database.database().reference()
    
    // MARK: - ViewModel Instantiation
//    var recipeViewModels = [RecipeViewModel]()
    var recipeViewModels2 = [RecipeViewModel2]()

    /// CoreData Setup
    var coreDataDB = CoreDataDB(persistenceManager: PersistenceManager.shared)
    
    // MARK: - Properties
    //    var favoritedPostArray = [FavoritedPost]()
    let notificationCenter = UNUserNotificationCenter.current()
    
    let defaults = UserDefaults.standard
    var buttonStates = [Bool]()
        
    var isFetching = false
    
    struct Keys {
        static let hearted = "hearted"
    }
    
    fileprivate let homeCellID = "cellID"
    fileprivate let headerCellID = "headerID"
    fileprivate let loadingCellID = "loadingID"
    
    fileprivate let imageSaved = UIImage(systemName: "heart.fill")
    fileprivate let imageUnsaved = UIImage(systemName: "heart")
    
    //    fileprivate var favoritedPostArray = [1] //.map { FavoritedRecipe(name: $0, hasFavorited: false)}
    
    lazy var refresher: UIRefreshControl = {
        let rc = UIRefreshControl()
//        rc.isEnabled = false
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    lazy var welcomingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""//"Hello, Valter!"
        lbl.textColor = UIColor(named: "userNameLabelAppearance")
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        
        /// Adding refreshControl to iOS 10.0 and above
        if #available(iOS 10.0, *) {
            cv.refreshControl = refresher
        } else {
            cv.addSubview(refresher)
        }
        
        cv.delegate = self
        cv.dataSource = self
        cv.register(HomeCell.self, forCellWithReuseIdentifier: homeCellID)
        cv.register(LoadingCell.self, forCellWithReuseIdentifier: loadingCellID)
        cv.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellID)
        return cv
    }()
    
    let screenSize = UIScreen.main.bounds.size
    let transparentView = UIView()
    
    // ProfileMenu Components X, Y size
    let centerHandlerViewHeight: CGFloat = 5
    let centerHandlerViewWidth: CGFloat = 50
    
    var profileMainViewHeight: CGFloat = 155
    var profileMenuSVHeight: CGFloat = 127
    var adjustedHeight: CGFloat = 87
    var adjustedHeight2: CGFloat = 102
    
    let profileMenuSVWidth = (UIScreen.main.bounds.width - 40)
    let adjustedProfileMenuSVWidth = (UIScreen.main.bounds.width - 40) - 48*2
    
    lazy var centerHandlerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        return view
    }()
    
    lazy var profileMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "profileMenuAppearance")
        return view
    }()
    
    lazy var userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Valter Machado"
        lbl.textColor = UIColor(named: "userNameLabelAppearance")
        lbl.font = .systemFont(ofSize: 16)
        return lbl
    }()
    
    lazy var userEmailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "username@gmail.com"
        lbl.textColor = UIColor(named: "userEmailLabelAppearance")
        lbl.font = .systemFont(ofSize: 13)
        return lbl
    }()
    
    lazy var logOutBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Log Out", for: .normal)
        btn.tintColor = .systemPink
        btn.contentHorizontalAlignment = .right
        //        btn.backgroundColor = .blue
        btn.withWidth(70)
        btn.addTarget(self, action: #selector(logoutBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var favoritedCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "23 Recipes"
        lbl.textColor = UIColor(named: "userEmailLabelAppearance")
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 13)
        //        lbl.backgroundColor = .purple
        lbl.layer.cornerRadius = 4
        lbl.layer.borderColor = .init(srgbRed: 235/255, green: 69/255, blue: 90/255, alpha: 1)
        lbl.layer.borderWidth = 1.5
        lbl.withWidth(120)
        return lbl
    }()
    
    lazy var userProfileView: UIImageView = {
        let iv =  UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let recipeImage = UIImage(named: "food.jpg")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //        iv.backgroundColor = .blue
        iv.withWidth(40)
        iv.image = recipeImage
        iv.layer.cornerRadius = iv.frame.size.height/2
        iv.layer.borderColor = .init(srgbRed: 235/255, green: 69/255, blue: 90/255, alpha: 1)
        iv.layer.borderWidth = 1.5
        return iv
    }()
    
    lazy var profileMenuSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [userProfileView, innerStackView, logOutBtn])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        sv.distribution = .fillProportionally
        //        sv.addBackground(color: .red)
        return sv
    }()
    
    lazy var innerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [userNameLabel, userEmailLabel])
        sv.axis = .vertical
        //        sv.alignment = .center
        sv.spacing = -4
        sv.distribution = .fillProportionally
        //        sv.addBackground(color: .blue)
        return sv
    }()
    
    lazy var favoritedCountSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [favoritedCountLabel])
        sv.axis = .vertical
        sv.alignment = .leading
        //        sv.spacing = 10
        sv.distribution = .fillProportionally
        //        sv.addBackground(color: .yellow)
        return sv
    }()
    
    // MARK: - PopUp window property
    lazy var popUpView: PopUpWindow = {
        let view = PopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    var scheduledTimer: Timer?
    
    lazy var shimmerView: ShimmeringView = {
        let shimmer = ShimmeringView()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
//        shimmer.backgroundColor = .gray
        return shimmer
    }()
    
    lazy var viewForShimmer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "shimmerAppearance")
        return view
    }()
    
    let config = UIImage.SymbolConfiguration(pointSize: CGFloat(30))
    lazy var wiredProfileImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: config)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    
    // RightNavBarBtn
    lazy var profileBtn: UIButton = {
    let profileBtn = UIButton(type: .custom)
    profileBtn.imageView?.contentMode = .scaleAspectFill
    profileBtn.setImage(wiredProfileImage, for: .normal)
    profileBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    profileBtn.layer.cornerRadius = profileBtn.frame.size.height/2
    profileBtn.layer.masksToBounds = false
    profileBtn.clipsToBounds = true
    //        profileBtn.layer.borderWidth = 1.5
//    profileBtn.backgroundColor = .red
    profileBtn.sizeToFit()
    //        profileBtn.layer.borderColor = UIColor.red.cgColor
    
    /// height and width constrainnts of profileBtn
    let widthConstraint = profileBtn.widthAnchor.constraint(equalToConstant: 30)
    let heightConstraint = profileBtn.heightAnchor.constraint(equalToConstant: 30)
    heightConstraint.isActive = true
    widthConstraint.isActive = true
    profileBtn.addTarget(self, action: #selector(profileImagePressed), for: .touchUpInside)
        return profileBtn
    }()
    // MARK: - Init
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        setNavigationBar()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Real file: \(Realm.Configuration.defaultConfiguration.fileURL)")
        //setupLocalNotification()
        // Do any additional setup after loading view.
        
        userAuthViewModel.delegate = self
        userAuthViewModel.fetchCurrentUserInfo()
//        fetchData()
//        fetchDataFromCoreData()
//        recipeViewModels2.isEmpty ? (refresher.isEnabled = true) :  (refresher.isEnabled = false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        defaults.removeObject(forKey: Keys.hearted)
//        coreDataDB.resetAllRecords(in: "FavoritedPost")
        
        ///updates collectionView to fetch the latest buttonStates
        collectionView.reloadData()
        transparentView.backgroundColor = UIColor(named: "backgroundAppearance")
        /// Check device size
        if UIScreen.main.bounds.height <= 667 {
            profileMainViewHeight = 130 // 155
            profileMenuSVHeight = 107 // 127
            adjustedHeight = 67 // 87
            adjustedHeight2 = 82 // 102
        }
        
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        DispatchQueue.main.async {
        //            self.userProfileView.layer.cornerRadius = self.userProfileView.frame.size.height/2
        //        }
    }
    
    func fetchDataFromFBase(){
        let recipeRef = self.ref.child("JSON_Recipe")

        recipeRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let getKeys = snap.value as! NSDictionary
                let test = getKeys[0] // does not work
                print("keys: \(test)")
                print("keys2: \(getKeys)")
                
            }
        }
    }
    
    // MARK: - Functions/Methods
    fileprivate func fetchData() {
//        DispatchQueue.global(qos: .userInteractive).async {
//            Service2.shared.fetchRecipes(pagination: false) { (result) in
//                switch result {
//                case .success(let recipes):
//                    self.recipeViewModels = recipes?.map({ return RecipeViewModel2(recipe: $0)}) ?? []
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
//                case .failure(_):
//                    break
//                }
//            }

        Service2.shared.fetchRecipes { (recipes, err) in
            if let err = err {
                print("Failed to fetch recipes:", err)
                return
            }

            let data = recipes?.map({ return RecipeViewModel2(recipe: $0)}) ?? []
            self.recipeViewModels2.append(contentsOf: data) 
            /// Give default state to the buttons based on the amount of data retrieved
            for _ in 0..<(self.recipeViewModels2.count) {
                self.buttonStates.append(false)
                // in my case, all buttons are off, but be sure to implement logic here
            }
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func setupViews(){
        [collectionView].forEach({view.addSubview($0)})
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    fileprivate func setNavigationBar() {
        //        navigationController?.navigationBar.topItem?.title = "My Collections"
        /// navBar color
        //                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.hideNavBarSeperator()
        /// navBarItem color
        //            navigationController?.navigationBar.tintColor = UIColor.rgb(red: 235, green: 51, blue: 72)
        /// navBarTitle color
        //            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //            /// navBar  largeTitle color
        //            navigationController?.navigationBar.prefersLargeTitles = true
        //            navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        //            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        //
        /// add profileBtn to UIBarButtonItem on the left side
        let profileItem = UIBarButtonItem(customView: profileBtn)
        navigationItem.rightBarButtonItem =  profileItem
        
        let customLabel = UIBarButtonItem(customView: welcomingLabel)
        customLabel.tintColor = UIColor(named: "userNameLabelAppearance")
        navigationItem.leftBarButtonItem =  customLabel
        
    }
    
    private func storeUserDefaultsData(){
        defaults.set(buttonStates, forKey: Keys.hearted)
        defaults.synchronize()
    }
    
    private func getUserDefaultsData(){
        guard let indexPath = collectionView.indexPathForView(collectionView) else { return }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellID, for: indexPath) as! HomeCell
        
        if let stateArray = defaults.value(forKey: Keys.hearted) {
            let persistedStates : [Bool] = stateArray as! [Bool]
            //            print("View indexPath: \(indexPath)")
            //            if persistedStates[indexPath.item] {
            //                //on
            //                cell.saveButton.setImage(imageSaved, for: .normal)
            //                buttonStates[indexPath.item] = true
            //            } else {
            //                //off
            //                cell.saveButton.setImage(imageUnsaved, for: .normal)
            //                buttonStates[indexPath.item] = false
            //            }
        }
        collectionView.reloadData()
    }
    
    func setupLocalNotification() {
        //        notificationCenter.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Cook Time"
        content.body = "Cook something special for this weekend, access the best recipes."
        content.sound = .default
        
        // Scheduling notification
        let weekdaySet = [6, 7]
        for days in weekdaySet {
            
            let currentDate = Date()
            let calendar = Calendar.current
            
            let currentComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: currentDate)
            guard let weekDay = currentComponents.weekday else { return }
            //            guard let minutes = currentComponents.minute else { return }
            
            //            print(weekDay)
            
            if weekDay == days {
                print("success")
                let components = DateComponents(hour: 15, minute: 58, weekday: days)
                guard let date = calendar.date(from: components) else { return }
                
                let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                notificationCenter.add(request) { error in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                }
            } // End of loop
            print("failed")
        }
    }
    
    // MARK: - Link Method (HomeVCDelegate)
    // Using Custom Delegation (protocol): Works as a link between HomeVC and its cell to track the tapped indexPath
    func saveRecipeLinkMethod(cell: UICollectionViewCell, button: UIButton){
        /// Gets collectionView indexPath
        guard let tappedIndexPath = collectionView.indexPath(for: cell) else { return }
        
        buttonStates[tappedIndexPath.item] = !buttonStates[tappedIndexPath.item]
        //storeUserDefaultsData()
        
        let recipe = recipeViewModels2[tappedIndexPath.item]
        /// Converts JSON objects (codable) into dictionary (jsonString)
        guard let dict = try! JSONSerialization.jsonObject(with: try JSONEncoder().encode(recipe), options: []) as? [String: Any] else {return}
        
        var tempIngredArray: [String] = []
        recipe.ingredientArray?.forEach({ (list) in
            tempIngredArray.append(list.ingredient)
        })

        var tempNutriArray: [Any] = []
        if let nutrientArray = dict["nutrientArray"] {
            tempNutriArray.append(nutrientArray)
//            print("Arrays: \(tempNutriArray)")
        }
        
        // Save recipe
        if buttonStates[tappedIndexPath.item] == true {
            button.setImage(self.imageSaved, for: .normal)
            /// Processing backend service in the background thread
            DispatchQueue.global(qos: .background).async {
                // FireBase
                let newRef = self.ref.child("FavoritedRecipes").child("post: \(recipe.id)")
                newRef.updateChildValues(dict)
                /// Load url image to UIImage using cache
                UrlImageLoader.sharedInstance.imageForUrl(urlString: recipe.image, completionHandler: { [self] (image, url) in
                    if image != nil {
                        // CoreData presistence
                        self.coreDataDB.checkIfItemExist(id: recipe.id, name: recipe.name, image: image, ingredArray: tempIngredArray, duration: recipe.duration, servingsNo: Int32(recipe.numberOfServings), prepArray: recipe.preparationStepsArray, nutriArray: tempNutriArray, sourceUrl: recipe.sourceUrl)
                    }
                })

            }
            print("selected")
            
        // Unsave recipe
        } else {
            button.setImage(imageUnsaved, for: .normal)
            DispatchQueue.global(qos: .background).async {
                self.ref.child("FavoritedRecipes/post: \(recipe.id)").removeValue()
                self.coreDataDB.deleteItem(name: recipe.name)
            }
            print("deselected")
        }
 
//        print("buttonStates: \(buttonStates)")
        
        /// Reloads collectionView to update cells with the latest changes
        collectionView.reloadItems(at: [tappedIndexPath])
        Vibration.medium.vibrate()
        /// Custom access to HomeCell
        guard let outsiderHomeCellAccess = collectionView.cellForItem(at: tappedIndexPath) as? HomeCell else { return }
        
        //        let windowWithOptional = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        //        guard let window = windowWithOptional else { return }
        
        /// PopUpWindow (is being added directly to the HomeCell class using a custom outsider variable)
        outsiderHomeCellAccess.addSubview(popUpView)
        
        NSLayoutConstraint.activate ([
            popUpView.centerYAnchor.constraint(equalTo: outsiderHomeCellAccess.transparentView.centerYAnchor, constant: 0),
            popUpView.centerXAnchor.constraint(equalTo: outsiderHomeCellAccess.transparentView.centerXAnchor),
            popUpView.heightAnchor.constraint(equalToConstant: 100),
            popUpView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        popUpView.showSuccessMessage = buttonStates[tappedIndexPath.item]  /// Shows popup based on the button indexppath state
        popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        UIView.animate(withDuration: 0.6, animations: {
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }) { (Bool) in
            self.handleDismissal()
        }
        //
        print("saveRecipeLinkMethod")
    } // End of saveRecipeLinkMethod
    
    
    // MARK: - Selectors
    @objc private func logoutBtnPressed() {
        do {
            try Auth.auth().signOut()
            // Switch rootView in order to avoid memory leak as well as stack of views 
            let onboardingVC = UINavigationController(rootViewController: OnboardingVC())
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(onboardingVC)
        } catch let logoutError {
            print(logoutError)
        }
        
//        let onboardingVC = OnboardingVC()
//        let navigationController = UINavigationController(rootViewController: onboardingVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: false, completion: nil)
//        print("Logout")
    }
    
    @objc func refreshData(_ refreshController: UIRefreshControl){
        print("123")
        
        let refreshDeadline = DispatchTime.now() + .seconds(Int(1.5))
        DispatchQueue.main.asyncAfter(deadline: refreshDeadline) {
            refreshController.endRefreshing()
        }
        
    }
    
    @objc private func profileImagePressed(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        transparentView.addGestureRecognizer(tap)
        
        // window
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        // transparentView
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        transparentView.frame = view.frame
        window?.addSubview(transparentView)
        
        // profileMainView
        profileMainView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: profileMainViewHeight)
        window?.addSubview(profileMainView)
        
        // profileMenuSV
        profileMenuSV.frame = CGRect(x: (self.screenSize.width - self.profileMenuSVWidth) / 2, y: screenSize.height, width: screenSize.width, height: profileMenuSVHeight - adjustedHeight)
        window?.addSubview(profileMenuSV)
        
        // favoritedCountSV
        favoritedCountSV.frame =  CGRect(x: (self.screenSize.width - adjustedProfileMenuSVWidth) / 2, y: screenSize.height, width: screenSize.width, height: profileMenuSVHeight - adjustedHeight2)
        window?.addSubview(favoritedCountSV)
        
        // centerHandlerView
        centerHandlerView.frame = CGRect(x: (screenSize.width - centerHandlerViewWidth) / 2, y: screenSize.height, width: centerHandlerViewWidth, height: centerHandlerViewHeight)
        window?.addSubview(centerHandlerView)
        
        transparentView.alpha = 0
        // Shows Slide up menu
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            //            self.navigationController?.navigationBar.barStyle = .black
            self.transparentView.alpha = 0.8
            
            self.favoritedCountSV.frame = CGRect(x:  (self.screenSize.width - self.adjustedProfileMenuSVWidth) / 2, y: (self.screenSize.height - self.profileMenuSVHeight) + 45, width: self.adjustedProfileMenuSVWidth, height: self.profileMenuSVHeight - self.adjustedHeight2)
            
            self.profileMenuSV.frame = CGRect(x:  (self.screenSize.width - self.profileMenuSVWidth) / 2, y: (self.screenSize.height - self.profileMenuSVHeight), width: self.profileMenuSVWidth, height: self.profileMenuSVHeight - self.adjustedHeight)
            
            self.profileMainView.frame = CGRect(x: 0, y: self.screenSize.height - self.profileMainViewHeight, width: self.screenSize.width, height: self.profileMainViewHeight)
            
            self.centerHandlerView.frame = CGRect(x: (self.screenSize.width - self.centerHandlerViewWidth) / 2, y: self.screenSize.height - (self.profileMainViewHeight - 8), width: self.centerHandlerViewWidth, height: self.centerHandlerViewHeight)
            
            self.profileMainView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        }, completion: nil)
        
        print("User Profile")
    } // End of profileImagePressed selector
    
    // Hides Slide up menu
    @objc fileprivate func viewTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            //            self.navigationController?.navigationBar.barStyle = .default
            self.transparentView.alpha = 0
            
            self.favoritedCountSV.frame = CGRect(x:  (self.screenSize.width - self.adjustedProfileMenuSVWidth) / 2, y: self.screenSize.height, width: self.adjustedProfileMenuSVWidth, height: self.profileMenuSVHeight - self.adjustedHeight2)
            
            self.profileMenuSV.frame = CGRect(x: (self.screenSize.width - self.profileMenuSVWidth) / 2, y: self.screenSize.height, width: self.profileMenuSVWidth, height: self.profileMainViewHeight - self.adjustedHeight)
            
            self.profileMainView.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.profileMainViewHeight)
            
            self.centerHandlerView.frame = CGRect(x: (self.screenSize.width - self.centerHandlerViewWidth) / 2, y: self.screenSize.height, width: self.centerHandlerViewWidth, height: self.centerHandlerViewHeight)
        }, completion: nil)
    }
    
}



// MARK: - HomeVC collectionView extension
extension HomeVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellID, for: indexPath) as! HomeHeader
        //        if indexPath.section == 1 {
        //            headerCell.isHidden = true
        //            return headerCell
        //        }
        //        headerCell.backgroundColor = .red
        
        //
        //        headerCell.isHidden = false
        
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: view.frame.width, height: 110)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
//            recipeViewModels2.isEmpty ? (0) : (recipeViewModels2.count)
            return recipeViewModels2.isEmpty ? (tempArray.count) : (recipeViewModels2.count)
        } else if section == 1 && !isFetching {
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellID, for: indexPath) as! HomeCell
        let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCellID, for: indexPath) as! LoadingCell
        
        cell.linkDelegate = self
        
        // return loading collectionViewCell
        if indexPath.section == 1 {
            loadingCell.indicator.start()
            return loadingCell
        }
        // return regular UICollectionViewCell
        /// check if didFinish data, if not run shimmer animation
        if recipeViewModels2.isEmpty != true {
            collectionView.isUserInteractionEnabled = true

            cell.shimmerView.isShimmering = false
            // fadeOut viewForShimmer
            cell.viewForShimmer.fadeOut()
            // fadeIut views to give a clean shimmer animation
            cell.recipeImageView.fadeIn()
            cell.recipeNameLabel.fadeIn()
            cell.recipeOwnerImageView.fadeIn()
            cell.recipeOwnerLabel.fadeIn()
            cell.saveButton.fadeIn()
            cell.reviewLabel.fadeIn()
            cell.ratingLabel.fadeIn()

            cell.shimmerView.isHidden = true
           
//            let name = savedRecipes[indexPath.item].name

            let recipeViewModel = recipeViewModels2[indexPath.item]
            cell.recipeViewModel = recipeViewModel
            /// Check favorited recipes
            ref.child("FavoritedRecipes/post: \(recipeViewModel.id)/name").observeSingleEvent(of: .value) { (snapshot) in
                let name = snapshot.value as? String
                if name == recipeViewModel.name {
                    cell.saveButton.setImage(self.imageSaved, for: .normal)
                    /// restoure the button state to the state saved in the firebase
                    self.buttonStates[indexPath.item] = true
                } else {
                    cell.saveButton.setImage(self.imageUnsaved, for: .normal)
                    /// restoure the button state to the state saved in the firebase
                    self.buttonStates[indexPath.item] = false
                }
            }
        } else {
            // disable userInteraction while shimmer animation is running for a good UX
            collectionView.isUserInteractionEnabled = false
            // fadeIn viewForShimmer
            cell.viewForShimmer.fadeIn()
            // fadeOut views to give a clean shimmer animation
            cell.recipeImageView.fadeOut()
            cell.recipeNameLabel.fadeOut()
            cell.recipeOwnerImageView.fadeOut()
            cell.recipeOwnerLabel.fadeOut()
            cell.saveButton.fadeOut()
            cell.reviewLabel.fadeOut()
            cell.ratingLabel.fadeOut()
            // add the customView to shimmerContent
            cell.shimmerView.contentView = cell.viewForShimmer
            cell.shimmerView.isShimmering = true
            cell.shimmerView.isHidden = false
        }
        return cell
    } // End of cellForItemAt func
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width - 20, height: 30)
        }
        
        /// Check device size
        if UIScreen.main.bounds.height <= 667 {
            return CGSize(width: view.frame.width - 20, height: view.frame.height/1.7)
        }
        
        return CGSize(width: view.frame.width - 20, height: view.frame.height/1.99)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // give space top left bottom and right for cells
        if section == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = HomeDetailVC()
        
        let indexedRecipe = recipeViewModels2[indexPath.item]
        detailVC.recipeID = indexedRecipe.id
        detailVC.recipeSourceUrl = indexedRecipe.sourceUrl
        detailVC.recipeNameLabel.text = indexedRecipe.name
//        detailVC.recipeImageView.image = UIImage(imageLiteralResourceName: indexedRecipe.image)
//        print("arrayCount: \(indexedRecipe.nutrientArray?.count)")

        detailVC.buttonStatesHomeVC = buttonStates
        detailVC.indexPathHomeVC = indexPath
        detailVC.recipeItemIndexPath = indexedRecipe
        detailVC.title = "Quick and Easy".uppercased()
//        detailVC.indexedIngredArray = indexedRecipe.ingredientArray ?? []
            
        UrlImageLoader.sharedInstance.imageForUrl(urlString: indexedRecipe.image, completionHandler: { (image, url) in
            if image != nil {
                detailVC.recipeImageView.image = image
            }
        })

        detailVC.durationLabel.text = indexedRecipe.duration
        detailVC.servingsLbl = indexedRecipe.numberOfServings
        
        /// Prevent app from crash because of nil/empty object coming from the json array
        if !indexedRecipe.nutrientArray!.isEmpty {
            /// Prevent app from crash because of missing object in json array
            if indexedRecipe.nutrientArray!.contains(where: { $0.nutrientName == "FAT" }) {
                print("FAT exists in the array")
                detailVC.calLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![0].nutrientAmount) + " kcal"
                detailVC.fatsLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![13].nutrientAmount) + " g"
            } else {
                print("FAT does not exists in the array")
                detailVC.calLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![1].nutrientAmount) + " kcal"
                detailVC.fatsLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![2].nutrientAmount) + " g"
            }
            print("indexedRecipe: \(indexPath.item)")

        } else {
            detailVC.calLabel.text = "N/A"
            detailVC.fatsLabel.text = "N/A"
        }

        detailVC.nutritionArray = indexedRecipe.nutrientArray!
        detailVC.ingredientArray = indexedRecipe.ingredientArray!
        detailVC.preparationSteps = indexedRecipe.preparationStepsArray
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let positionY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
//        (positionY > (contentHeight - scrollView.frame.height*1.6) + 5) && (positionY != 0.0)
        //        print("offSetY: \(offSetY) | heightContent: \(contentHeight) scrollViewHeight: \(scrollView.frame.height)")
        
        if  (positionY > (contentHeight - scrollView.frame.height*1.6) + 5) && (positionY != 0.0) {
            
            if !isFetching {
                beginFetchMoreData()
            }
            
        }
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        let lastItem = viewModel.recipePostArray.count - 1
    //        if indexPath.item == lastItem {
    //            if !isFetching {
    //                beginFetchMoreData()
    //            }
    //        }
    //
    //    }
    
    func beginFetchMoreData(){
        isFetching = true
        print("beginBatchFetch!")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        Service2.shared.fetchRecipesForNewData { (recipes, err) in
            if let err = err {
                print("Failed to fetch recipes:", err)
                return
            }
            let newFetchedData = recipes?.map({ return RecipeViewModel2(recipe: $0)}) ?? []
            // filter new data to avoid redundant items in the array
            let newData = newFetchedData.filter { $0.name != "Melt-In-Your-Mouth Baked Chicken Breasts" }
            self.recipeViewModels2.append(contentsOf: newData)
            // if newDataArray isn't populated yet isFetching is true
            newData.isEmpty == true ? (self.isFetching = false) : (self.isFetching = true)
            /// Give default state to the buttons based on the amount of data retrieved
            for _ in 0..<(self.recipeViewModels2.count) {
                self.buttonStates.append(false)
                // in my case, all buttons are off, but be sure to implement logic here
            }
//            self.isFetching = false
            self.collectionView.reloadData()
        }
//        })
        
//                collectionView.reloadSections(IndexSet(integer: 1))
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
////         Specify how many items to update (obs: the code structure alone already increment 1 item to the existing array)
////                    let newItems = (self.viewModel.recipePostArray.count...self.viewModel.recipePostArray.count).map {index in index}
////                    self.viewModel.recipePostArray.append(contentsOf: newItems as! [Recipe])
//                    self.isFetching = false
//
//                    self.collectionView.reloadData()
//                })
        
        //        for _ in 1 ..< 10 {
        //            var lastItem = viewModel.recipePostArray.last
        //            let newItem = lastItem + 1 as? Recipe
        //            viewModel.recipePostArray.append(newItem)
        //            self.isFetching = false
        //            collectionView.reloadData()
        //        }
        
    }
    
    
} // End of HomeVC


extension HomeVC: PopUpDelegate {
    
    func handleDismissal() {
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            // bug fixing (does not permit for the popUpView be removed in a faster way)
            self.popUpView.removeFromSuperview()
            print("Did remove pop up window..")
        }
    }
    
    
}

// MARK: - UserAuthSingleton Extension
extension HomeVC: UserAuthSingleton {
    
    func userAuthCallBack(errorMessage: String) {
        print(errorMessage)
    }
    
    // User Signed in successfully
    func didEndFetchingUserInfo(didFetchInfo state: Bool, firstName: String, lastName: String, email: String, profileImageUrl: String, numberOfFaveRecipes: Int) {
      
//        profileBtn.tintColor = .red
        /// Load ulr image to UIImage variable
        UrlImageLoader.sharedInstance.imageForUrl(urlString: profileImageUrl, completionHandler: { (image, url) in
            if image != nil {
                
                self.userProfileView.image = image
                self.profileBtn.setImage(image, for: .normal)

            }
        })

        self.userNameLabel.text = "\(firstName) " + lastName
        self.userEmailLabel.text = email
        self.welcomingLabel.text = "Hello, \(firstName)!"
        
    }
    
    
}

//struct EndPoint: Codable {
//    var q: String
////    var count: String
//    var hits: [Hits]
//}
//
//struct Hits: Codable {
//   
//    var recipe: Recipe2
//    
//    private enum RootKeys: String, CodingKey {
//        case recipe
//    }
//    init(from decoder: Decoder) throws {
//        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
//        recipe = try rootContainer.decode(Recipe2.self, forKey: .recipe)
//    }
//   
//}
//
//struct Recipe2: Codable {
//    var name: String
//    private enum RecipeKeys: String, CodingKey {
//        case name = "label"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let rootContainer = try decoder.container(keyedBy: RecipeKeys.self)
//        name = try rootContainer.decode(String.self, forKey: .name)
//    }
//}
