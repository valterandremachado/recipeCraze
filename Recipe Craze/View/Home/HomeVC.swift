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
import GoogleSignIn
import RealmSwift

let notificationID = "notificationID"

class HomeVC: UIViewController, HomeVCDelegate {
    
    let tempArray = ["1", "2"]
    var savedRecipes = [FavoritedRecipeToCD]()
    
    var userUID = ""
    var likedRecipeNo = 0
    var persistedUserName = ""
    
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
        static let excuteOnceWhenViewWillAppear = "ExecuteOnce"
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
        lbl.text = "..."//"Hello, \(persistedUserName)"
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
        lbl.text = "No Recipe Saved"
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
    
    var recipeRealmObject: Results<RecipeRealmObject>!
    // RealmDB
    var realmDB = RealmService.shared.realm
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        setNavigationBar()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Real file: \(Realm.Configuration.defaultConfiguration.fileURL)")
        //setupLocalNotification()
        // Do any additional setup after loading view.
        storeUserUIDInRealm()
        userAuthViewModel.delegate = self
        userAuthViewModel.fetchCurrentUserInfo()

        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        defaults.removeObject(forKey: Keys.excuteOnceWhenViewWillAppear)
//        coreDataDB.resetAllRecords(in: "FavoritedRecipeToCD")
        // Changes userDefaults value in order to run it only once every time the HomeVC is opened
//        defaults.set(false, forKey: Keys.excuteOnceWhenViewWillAppear)
//        defaults.synchronize()
        
        // Refresh collectionView when user is coming from a different VC
        if recipeViewModels2.isEmpty == false {
            updateCollectionViewWithFavoritedVCChanges()
        }
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        //        DispatchQueue.main.async {
//        //            self.userProfileView.layer.cornerRadius = self.userProfileView.frame.size.height/2
//        //        }
//    }
    
    func storeUserUIDInRealm(){
        recipeRealmObject = realmDB.objects(RecipeRealmObject.self)
        
        recipeRealmObject.forEach({ (object) in
            persistedUserName = object.userFirstName ?? "..."
        })
        
        self.welcomingLabel.text = "Hello, \(persistedUserName)!"
    }
    
    // MARK: - Functions/Methods
    fileprivate func fetchData() {
        if Auth.auth().currentUser != nil {
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
                // Check if the user has been auth (bug fix: problem with loading even with no user auth)
                if !self.userUID.isEmpty {
                    // didRefreshAfter recipeViewModels2 is fetched observer
                    NotificationCenter.default.post(name: Notification.Name("didRefreshCellsAfterFetchDataNotification"), object: nil, userInfo: nil)
                }
                
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func fetchDataFromCoreData(){
        /// Threading: Task completes immediately to give a nice UX
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            let managedContext = self.coreDataDB.persistenceManager.context
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedRecipeToCD")

            do {
                self.savedRecipes = try managedContext.fetch(fetchRequest) as! [FavoritedRecipeToCD]

                DispatchQueue.main.async {
                    if savedRecipes.count == 0 {
                        self.favoritedCountLabel.text = "No Recipe Saved"
                    } else if savedRecipes.count == 1 {
                        self.favoritedCountLabel.text = "\(savedRecipes.count) Recipe"
                    } else {
                        self.favoritedCountLabel.text = "\(savedRecipes.count) Recipes"
                    }
//                    }
                }

            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
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

        /// add profileBtn to UIBarButtonItem on the left side
        let profileItem = UIBarButtonItem(customView: profileBtn)
        navigationItem.rightBarButtonItem =  profileItem
        
        let customLabel = UIBarButtonItem(customView: welcomingLabel)
        customLabel.tintColor = UIColor(named: "userNameLabelAppearance")
        navigationItem.leftBarButtonItem =  customLabel
        
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
    
    func updateCollectionViewWithFavoritedVCChanges() {
        
        for i in 0..<collectionView.numberOfSections {
            for j in 0..<collectionView.numberOfItems(inSection: i) {

                let indexPath = IndexPath(row: j, section: i)
                let recipeViewModel = recipeViewModels2[indexPath.item]
//                print("recipeViewModel: \(recipeViewModel)")
                
                ref.child("users/\(userUID)/favoritedRecipes/recipeID: \(recipeViewModel.id)/name").observeSingleEvent(of: .value) { [self] (snapshot) in
                    
                    var nameArray = [String]()
                    let name = snapshot.value as? String ?? ""
                    nameArray.append(name)
                    
                    for names in nameArray {
                        if names == recipeViewModel.name {
                            self.buttonStates[indexPath.item] = true
                        } else {
                            self.buttonStates[indexPath.item] = false
                        }
                    }
                    collectionView.reloadData()
                }
                print("update...")
                collectionView.reloadData()
                
            }
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
        }

        // Save recipe
        if buttonStates[tappedIndexPath.item] == true {
            likedRecipeNo += 1
            buttonStates[tappedIndexPath.item] = true
            button.setImage(self.imageSaved, for: .normal)
            /// Processing backend service in the background thread
            DispatchQueue.global(qos: .background).async { [self] in
                // FireBase
                let newRef = self.ref.child("users/\(userUID)/favoritedRecipes").child("recipeID: \(recipe.id)")
                newRef.updateChildValues(dict)
                let newRef2 = self.ref.child("users/\(userUID)")
                newRef2.updateChildValues(["numberOfFaveRecipes": likedRecipeNo])
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
            likedRecipeNo == 0 ? (likedRecipeNo = 0) : (likedRecipeNo -= 1)
//            likedRecipeNo -= 1
//            buttonStates[tappedIndexPath.item] = false
            button.setImage(imageUnsaved, for: .normal)
            DispatchQueue.global(qos: .background).async { [self] in
                let newRef2 = self.ref.child("users/\(userUID)")
                newRef2.updateChildValues(["numberOfFaveRecipes": likedRecipeNo])
    
                self.ref.child("users/\(userUID)/favoritedRecipes/recipeID: \(recipe.id)").removeValue()
                self.coreDataDB.deleteItem(name: recipe.name)
            }
            print("deselected")
        }
         
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
    @objc func collectionViewFetchedItemsObserver() {
        updateCollectionViewWithFavoritedVCChanges()
//        print("collectionViewFetchedItemsObserver")
    }
    
    @objc private func logoutBtnPressed() {
        viewTapped()
        
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { [self] UIAlertAction in
            
            // SignOut user linked with GoogleSignIn
            GIDSignIn.sharedInstance()?.signOut()
            do {
                // SignOut user
                try Auth.auth().signOut()
                // Delete user's data from core Data
                self.coreDataDB.resetAllRecords(in: "FavoritedRecipeToCD")
                // Delete user info in the realmDB
                try! realmDB.write {
                    realmDB.delete(recipeRealmObject)
                }
                // Switch rootView in order to avoid memory leak as well as stack of views
                let onboardingVC = UINavigationController(rootViewController: OnboardingVC())
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(onboardingVC)
            } catch let logoutError {
                print(logoutError)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in }
        
        alertController.view.tintColor = .systemPink
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func refreshData(_ refreshController: UIRefreshControl){
        print("123")
        
        let refreshDeadline = DispatchTime.now() + .seconds(Int(1.5))
        DispatchQueue.main.asyncAfter(deadline: refreshDeadline) {
            self.fetchData()
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
            self.fetchDataFromCoreData()

        }, completion: nil)
        
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
                
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewFetchedItemsObserver), name: NSNotification.Name("didRefreshCellsAfterFetchDataNotification"), object: nil)
 
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
            
            let recipeViewModel = recipeViewModels2[indexPath.item]
            cell.recipeViewModel = recipeViewModel
            
            // buttonStates switcher
            if self.buttonStates[indexPath.item] == true {
                cell.saveButton.setImage(self.imageSaved, for: .normal)
                self.buttonStates[indexPath.item] = true
            } else {
                cell.saveButton.setImage(self.imageUnsaved, for: .normal)
                self.buttonStates[indexPath.item] = false
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
        detailVC.userUID = userUID
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
//                print("FAT exists in the array")
                detailVC.calLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![0].nutrientAmount) + " kcal"
                detailVC.fatsLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![13].nutrientAmount) + " g"
            } else {
                print("FAT does not exists in the array")
                detailVC.calLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![1].nutrientAmount) + " kcal"
                detailVC.fatsLabel.text = String(format:"%.0f", indexedRecipe.nutrientArray![2].nutrientAmount) + " g"
            }
//            print("indexedRecipe: \(indexPath.item)")

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
    func didEndFetchingUserInfo(didFetchInfo state: Bool, userUID: String, firstName: String, lastName: String, email: String, profileImageUrl: String, numberOfFaveRecipes: Int) {
      
        /// Load ulr image to UIImage variable
        UrlImageLoader.sharedInstance.imageForUrl(urlString: profileImageUrl, completionHandler: { (image, url) in
            if image != nil {
                
                self.userProfileView.image = image
                self.profileBtn.setImage(image, for: .normal)

            }
        })
        
        self.userUID = userUID
        self.userNameLabel.text = "\(firstName) " + lastName
        self.userEmailLabel.text = email
        
        var persistedUserUID = ""
        recipeRealmObject.forEach({ (object) in persistedUserUID = object.realmUserUID!})
        // Checking if it's first time user
        if persistedUserUID.isEmpty != false {
            let newObject = RecipeRealmObject(id: UUID().uuidString, realmUserUID: userUID, userFirstName: firstName)
            RealmService.shared.create(newObject)
            recipeRealmObject.forEach({ (object) in
                persistedUserUID = object.realmUserUID!
                persistedUserName = object.userFirstName!
            })
            self.welcomingLabel.text = "Hello, \(persistedUserName)!"
        }

        if persistedUserUID != userUID {
            // Update realmDB
            if let recipeObject = recipeRealmObject.first {
                try! realmDB.write {
                    recipeObject.userFirstName = firstName
                    recipeObject.realmUserUID = userUID
                }
            }
            
            recipeRealmObject.forEach({ (object) in
                persistedUserUID = object.realmUserUID!
                persistedUserName = object.userFirstName ?? ""
                
                self.welcomingLabel.text = "Hello, \(persistedUserName)!"
            })

        } else {
            print("old UserUID: \(persistedUserUID)")
            self.welcomingLabel.text = "Hello, \(persistedUserName)!"
        }
        
        
        // Restore user's favorited recipes then persist it with Core Data right after user is signedIn
        let customerRef = self.ref.child("users").child("\(userUID)").child("favoritedRecipes")
        
        customerRef.observe(.childAdded, with: { snapshot in
            
            var recipeIDArray = [String]()
            let recipeIDs = snapshot.childSnapshot(forPath: "id")
            
            guard let ids = recipeIDs.value as? String else { return }
            recipeIDArray.append(ids)
            
            for recipeID in recipeIDArray {
                let customerRef = self.ref.child("users").child("\(userUID)").child("favoritedRecipes").child("recipeID: \(recipeID)")
                customerRef.observe(.value, with: { snapshot in
                    let recipeArray = snapshot.value as? [String : Any] ?? [:]
                    
                    let id = recipeArray["id"] as? String ?? "N/A"
                    let name = recipeArray["name"] as? String ?? "N/A"
                    let duration = recipeArray["duration"] as? String ?? "N/A"
                    let imageUrl = recipeArray["image"] as? String ?? "N/A"
                    let servingsNo = recipeArray["numberOfServings"] as? Int ?? 0
                    let sourceUrl = recipeArray["sourceUrl"] as? String ?? "N/A"
                    
                    let stepsArray = recipeArray["preparationStepsArray"] as? [String] ?? []
                    let nutriDict = recipeArray["nutrientArray"]
                    let nutriArray = [NSArray(array: nutriDict as? [Any] ?? [])]
                    let ingredDict = recipeArray["ingredientArray"] as? [NSDictionary] ?? []
                    var ingredArray = [String]()
                    
                    // Iterate through the Array<Dictionary> of Strings
                    ingredDict.forEach { ingredients in
                        for (_ , value) in  ingredients {
                            ingredArray.append(value as! String)
                        }
                    }
                    // check if the user have saved a recipe before in order to pull it back and save in the core data
                    if id != "N/A" {
                        /// Load url image to UIImage using cache
                        UrlImageLoader.sharedInstance.imageForUrl(urlString: imageUrl, completionHandler: { [self] (image, url) in
                            if image != nil {
                                // CoreData presistence
                                self.coreDataDB.checkIfItemExist(id: id, name: name, image: image, ingredArray: ingredArray, duration: duration, servingsNo: Int32(servingsNo), prepArray: stepsArray, nutriArray: nutriArray, sourceUrl: sourceUrl)
                            } // End of image scope
                        }) // End of UrlImageLoader scope
                        return
                    } // End if statement
                }) // End of inner observe scope
            } // End of recipeIDArray loop
        }) // End of outer observe scope
        
    } // End of didEndFetchingUserInfo function
    
    
} // End of the class
