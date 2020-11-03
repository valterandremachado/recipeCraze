//
//  FavoriteVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

enum SelectionMode {
    case more
    case select
//    case cancel
}

enum CancelMode {
    case cancel
    case more
}

class FavoriteVC: UIViewController {
    
    let tempArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
                     "13", "14", "15", "16", "16", "17", "18", "19", "22", "23", "24", "25"]

    // MARK: - ViewModel Instantiation
    var recipeViewModels = [RecipeViewModel2]()
    /// CoreData Setup
    var coreDataDB = CoreDataDB(persistenceManager: PersistenceManager.shared)
    /// FirebaseDB Setup
    let ref = Database.database().reference()
    
    /// Arrays
    lazy var ingredientArray = recipeViewModels.first?.ingredientArray
//    lazy var nutritionArray = recipeViewModels.first?.nutrientArray
//    lazy var preparationSteps = recipeViewModels.first?.preparationStepsArray
    
    // MARK: - Properties
    var favoritedPostArray = [FavoritedRecipeToCD]()
    private let faveCellID = "cellID"
    var selectedIndexPathDic: [IndexPath: Bool] = [:]

    var selectionMode: SelectionMode = .more {
        didSet {
            
            switch selectionMode {
                
            case .more:
                
                for (key, value) in selectedIndexPathDic {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                
                selectedIndexPathDic.removeAll()
                
                navigationItem.rightBarButtonItem = moreBarButton
                moreBarButton.image = UIImage(systemName: "ellipsis")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
                moreBarButton.title = nil

                navigationItem.leftBarButtonItem = nil
                collectionView.allowsMultipleSelection = false
                
            case .select:
                moreBarButton.image = UIImage(systemName: "")
                moreBarButton.title = "Cancel"
                moreBarButton.tintColor = .systemPink

                //          moreBarButton.image = UIImage(systemName: "ellipsis")
                navigationItem.leftBarButtonItem = unSaveBarButton
//                navigationItem.rightBarButtonItem = nil
                collectionView.allowsMultipleSelection = true
                
            }
        }
    }
    

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0.5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(FavoriteCell.self, forCellWithReuseIdentifier: faveCellID)
        return cv
    }()
    
    lazy var moreBarButton: UIBarButtonItem = {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(moreBarBtnPressed))
      return rightBarButton
    }()

    lazy var unSaveBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem(title: "Unsave", style: .plain, target: self, action: #selector(unSaveBarBtnPressed))
        leftBarButton.isEnabled = false
        leftBarButton.tintColor = .red
      return leftBarButton
    }()
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        setupViews()
//        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading view.
//        viewModel.getFavoritedPost()
        print("recipeViewModels: \(recipeViewModels)")
//        print("CoreData: \(favoritedPostArray.first?.ingredientCDArray)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        coreDataDB.resetAllRecords(in: "FavoritedPost")
        self.setupNavBar()
        self.fetchDataFromCoreData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) { [self] in
            guard let nav = navigationController?.navigationBar else { return }
            /// Make navBar visible again
            nav.isTranslucent = true
        }
       
    }
    
    // MARK: - Methods
    fileprivate func presentShareSheet(indexPath: IndexPath) {
        
        let thingsToShare = [favoritedPostArray[indexPath.item].name]
//        guard let image = UIImage(systemName: "bell"), let url = URL(string: "https://www.google.com") else { return }
        let shareSheetVC = UIActivityViewController(activityItems: thingsToShare, applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    fileprivate func addContextMenuInteraction(toCell cell: UICollectionViewCell) {
        /// Adding UIContextMenu to the collectionView
//        let interaction = UIContextMenuInteraction(delegate: self)
//        print("debugDescription: \(interaction.debugDescription)")
//        cell.addInteraction(interaction)
    }
    
    fileprivate func fetchDataFromCoreData(){
        /// Threading: Task completes immediately to give a nice UX
        DispatchQueue.global(qos: .userInteractive).async {
            let managedContext = self.coreDataDB.persistenceManager.context
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedRecipeToCD")
            //        let sortAlbum = NSSortDescriptor(key: "name", ascending: true)
            //        fetchRequest.sortDescriptors = [sortAlbum]
            //        fetchRequest.returnsObjectsAsFaults = false
            //
            do {
                self.favoritedPostArray = try managedContext.fetch(fetchRequest) as! [FavoritedRecipeToCD]
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
        
    }
    
    fileprivate func setupViews(){
        [collectionView].forEach({view.addSubview($0)})
        
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupNavBar(){
//        let backButton = UIBarButtonItem()
        guard let nav = navigationController?.navigationBar else { return }
        
        nav.prefersLargeTitles = false
        nav.barStyle = .default
        nav.titleTextAttributes = [.foregroundColor: UIColor(named: "labelAppearance")!]
        navigationItem.title = "Favorited"
        self.navigationItem.rightBarButtonItem = moreBarButton
        
        nav.isTranslucent = false
//        nav.showNavBarSeperator()
    }
    
    // MARK: - Selectors
    @objc private func moreBarBtnPressed(_ sender: UIButton){
        print("moreBarBtnPressed")
        
        let actionSheetAC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheetAC.view.tintColor = .systemPink

        let alertAC = UIAlertController(title: nil, message: "You have no favorited recipe to be selected.", preferredStyle: .alert)
        alertAC.view.tintColor = .systemPink

        let selectAction = UIAlertAction(title: "Select", style: .default) { alert in
            print("Select")
            if self.favoritedPostArray.isEmpty == false {
                self.selectionMode = self.selectionMode == .more ? .select : .more
                
            } else {
                let alert = UIAlertAction(title: "OK", style: .cancel)
                alertAC.addAction(alert)
                self.present(alertAC, animated: true)
                print("no item left")
                
            }
        } // End of selectAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        { (alert) in
//            self.selectionMode = self.selectionMode == .more ? .select : .more
//        }
        
        actionSheetAC.addAction(selectAction)
        actionSheetAC.addAction(cancelAction)
        
        if moreBarButton.title == "Cancel" {
            print("Cant open menu")
            self.selectionMode = self.selectionMode == .more ? .select : .more
            // bug fixing (clear completely selected items)
            collectionView.allowsSelection = true
            self.unSaveBarButton.isEnabled = false
            self.selectedIndexPathDic.removeAll()

        } else {
            actionSheetAC.fixActionSheetConstraintsError()
            present(actionSheetAC, animated: true)
        }
        
//        guard let indexPath = collectionView.indexPathForView(collectionView) else { return }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: faveCellID, for: indexPath) as! FavoriteCell
//        cell.emptyCheck.isHidden = false
    }
    
    @objc private func unSaveBarBtnPressed(){
//        guard let indexPath = collectionView.indexPathForView(collectionView) else { return }
//        self.cancelMode = self.cancelMode == .more ? .cancel : .more
//        collectionView.deselectItem(at: indexPath, animated: true)
        
        var dynamicRecipeText = ""
        var dynamicComplementText = ""
//        if selectedIndexPathDic.count > 1 {
//            message = "recipes"
//        }
        
        selectedIndexPathDic.count > 1 ? (dynamicRecipeText = "recipes") : (dynamicRecipeText = "recipe")
        selectedIndexPathDic.count > 1 ? (dynamicComplementText = "them") : (dynamicComplementText = "it")
        
        let alertAC = UIAlertController(title: "Unsave \(dynamicRecipeText)?", message: "Unsaving \(dynamicRecipeText) will remove \(dynamicComplementText) from your favorited collection.", preferredStyle: .alert)
        alertAC.view.tintColor = .systemPink
        
        let unsaveAction = UIAlertAction(title: "Unsave", style: .destructive) { _ in
            print("Unsave")
            
            var deleteNeededIndexPaths: [IndexPath] = []
            for (key, value) in self.selectedIndexPathDic {
                if value {
                    deleteNeededIndexPaths.append(key)
                }
            }
            
            for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
//                if self.favoritedPostArray[i.item].name <= 1 {
//                    
//                }
                // remove item from Firebase
                self.ref.child("FavoritedRecipes/post: \(self.favoritedPostArray[i.item].id ?? "")").removeValue()
                /// removes item from CoreData (must delete this item last to avoid index out of bound)
                self.coreDataDB.deleteItem(name: self.favoritedPostArray[i.item].name!)
                self.favoritedPostArray.remove(at: i.item)
            }
            
            self.collectionView.deleteItems(at: deleteNeededIndexPaths)
            self.selectedIndexPathDic.removeAll()
            self.selectionMode = self.selectionMode == .more ? .select : .more
            
        } // End of unsaveAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertAC.addAction(unsaveAction)
        alertAC.addAction(cancelAction)
        present(alertAC, animated: true)
        

    }

}

    // MARK: - CollectionView Extension
extension FavoriteVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritedPostArray.count
//favoritedPostArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: faveCellID, for: indexPath) as! FavoriteCell
        
//        if favoritedPostArray.isEmpty != true {
//            collectionView.isUserInteractionEnabled = true
//            cell.shimmerView.isShimmering = false
////            // fadeOut viewForShimmer
//            cell.viewForShimmer.fadeOut()
          
        let favorited = favoritedPostArray[indexPath.item]

        if let imageData = favorited.image {
            cell.favoritedImageView.image = UIImage(data: imageData)
        }
//        cell.highlightIndicator.isHidden = true
//        cell.selectIndicator.isHidden = true
        let widthConstraint = cell.heightAnchor.constraint(equalToConstant: 750)
        widthConstraint.priority = UILayoutPriority(rawValue: 750)
        widthConstraint.isActive = true
//        addContextMenuInteraction(toCell: cell)
//        } else {
//            // disable userInteraction while shimmer animation is running for a good UX
//            collectionView.isUserInteractionEnabled = false
//            // fadeIn viewForShimmer
//            cell.viewForShimmer.fadeIn()
//            // add the customView to shimmerContent
//            cell.shimmerView.contentView = cell.viewForShimmer
//            cell.shimmerView.isShimmering = true
//        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)

        switch selectionMode {
        case .more:
            let recipe = self.favoritedPostArray[indexPath.item]
            
            let detailVC = HomeDetailVC()
            detailVC.heartBtn.isHidden = true
//            detailVC.navigationController?.title = "Favorited"
            detailVC.title = "Favorited".uppercased()
            detailVC.recipeNameLabel.text = recipe.name
            detailVC.durationLabel.text = recipe.duration
            detailVC.servingsLbl = Int(recipe.servingsNo)
            
            detailVC.indexPathHomeVC = indexPath
            /// Threading: For a better UX
            DispatchQueue.global(qos: .userInteractive).async {
                guard let image = recipe.image else { return }
                DispatchQueue.main.async {
                detailVC.recipeImageView.image = UIImage(data: image)
                }
            }
            
            /// Fetching and converting arrays data in the Core Data to an Array of strings
            let ingredArray = (try? JSONSerialization.jsonObject(with: recipe.ingredientCDArray!, options: [])) as? [String]
            let prepArray = (try? JSONSerialization.jsonObject(with: recipe.preparationCDArray!, options: [])) as? [String]
            let nutriArray = (try? JSONSerialization.jsonObject(with: recipe.nutritionCDArray!, options: [])) as? [Any]

            let nutritionArrayCD = nutriArray![0] as? [NSDictionary]

            if !nutritionArrayCD!.isEmpty {
                // This condition handles the data coming from the CategoryVC (categoryVC is using a different API)
                if nutritionArrayCD!.count < 16 {
                    /// Prevent app from crash because of missing object in json array
                    if nutritionArrayCD!.count >= 4 {
                        print("FAT exists in the array")
                        detailVC.calLabel.text = "\(nutritionArrayCD![0]["nutrientAmount"] ?? "") kcal"
                        detailVC.fatsLabel.text = "\(nutritionArrayCD![13]["nutrientAmount"] ?? "") g"
                    } else {
                        print("FAT does not exists in the array")
                        detailVC.calLabel.text = "\(nutritionArrayCD![1]["nutrientAmount"] ?? "") kcal"
                        detailVC.fatsLabel.text = "\(nutritionArrayCD![2]["nutrientAmount"] ?? "") g"
                    }
                    print("indexedRecipe: \(indexPath.item)")
                } else {
                    detailVC.calLabel.text = "\(nutritionArrayCD![0]["amount"] ?? "") kcal"
                    detailVC.fatsLabel.text = "\(nutritionArrayCD![1]["amount"] ?? "") g"
                }
            } else {
                detailVC.calLabel.text = "N/A"
                detailVC.fatsLabel.text = "N/A"
            }
            
            // Let the shared DetailView know where the ingredientArray info is coming from to avoid ambiguity with HomeVC
            detailVC.faveIsVisible = self.isVisible
            detailVC.ingredientfromCD = ingredArray!
            
            detailVC.preparationSteps = prepArray
            detailVC.nutriCDArray = nutriArray!

            self.navigationController?.pushViewController(detailVC, animated: true)

            collectionView.deselectItem(at: indexPath, animated: true)
            print("more")
        case .select:
            print("selected")
            selectedIndexPathDic[indexPath] = true
            print("selectedIndexPathDic: \(selectedIndexPathDic)")
            checkSelectedIndexPathDic()
        }
        
//        let favoritedArray = favoritedPostArray[indexPath.item]
//        favoritedPostArray.remove(at: indexPath.item)
//        collectionView.deleteItems(at: [indexPath])
//        collectionView.reloadData()
    }
    
    func checkSelectedIndexPathDic(){
        if selectedIndexPathDic.count >= 1 {
            unSaveBarButton.isEnabled = true
        } else {
            unSaveBarButton.isEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
      if selectionMode == .select {
        
        selectedIndexPathDic[indexPath] = false
        selectedIndexPathDic.removeValue(forKey: indexPath)
        print("selectedIndexPathDic: \(selectedIndexPathDic)")
        checkSelectedIndexPathDic()
      }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 3
        
        /// changing sizeForItem when user switches through the segnment
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow)
        let finalSize = CGSize(width: size, height: size)
        
        return finalSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // give space top left bottom and right for cells
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let recipe = self.favoritedPostArray[indexPath.item]
            /// Fetching and converting arrays data in the Core Data to an Array of strings
            let nutriArray = (try? JSONSerialization.jsonObject(with: recipe.nutritionCDArray!, options: [])) as? [Any]
            let prepArray = (try? JSONSerialization.jsonObject(with: recipe.preparationCDArray!, options: [])) as? [String]

            let cookImage = UIImage(named: "cooking2")?.withTintColor(UIColor(named: "labelAppearance")!, renderingMode: .alwaysOriginal)
            let nutFactImage = UIImage(named: "nutrition")?.withTintColor(UIColor(named: "labelAppearance")!, renderingMode: .alwaysOriginal)
            
            // Create an action for sharing
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) {[self] _ in
                presentShareSheet(indexPath: indexPath)
            }
            
            let cookAction = UIAction(title: "Cook Now", image: cookImage) { [self] _ in
                
                let onScreenStepsVC = OnScreenStepsVC()
                onScreenStepsVC.foodNameLbl.text = recipe.name
                onScreenStepsVC.servingsLbl.text = "Servings: \(recipe.servingsNo)"
                /// Pass preparationStepsArray data through ViewModel to OnScreenStepsVC
                onScreenStepsVC.preparationStepsArray = prepArray
                onScreenStepsVC.modalPresentationStyle = .fullScreen
                present(onScreenStepsVC, animated: true)
            }
            
            let nutriFactAction = UIAction(title: "Nutrition Facts", image: nutFactImage) { [self] _ in
    
                let foodInfoVC = FoodInfoVC()
                let foodInfoVCWithNavBar = UINavigationController(rootViewController: foodInfoVC)
                foodInfoVC.title = recipe.name
                foodInfoVC.faveIsVisible = self.isVisible
                foodInfoVC.nutriCDArray =  nutriArray!
                present(foodInfoVCWithNavBar, animated: true)
            }

            let unsaveAction = UIAction(title: "Unsave", image: UIImage(systemName: "heart.slash"), attributes: .destructive) { [self] _ in
                                
                ref.child("FavoritedRecipes/post: \(favoritedPostArray[indexPath.item].id ?? "")").removeValue()
                /// removes item from CoreData
                coreDataDB.deleteItem(name: favoritedPostArray[indexPath.item].name!)
                favoritedPostArray.remove(at: indexPath.item)
                
                self.collectionView.deleteItems(at: [indexPath])
                self.selectedIndexPathDic.removeAll()                
            }
            
            let nutriArrayCount = nutriArray![0] as? [NSDictionary]
            
            let menu1 = UIMenu(title: "", children: prepArray?.count == 0 ? [shareAction, nutriFactAction, unsaveAction] : [shareAction, cookAction, nutriFactAction, unsaveAction])
            let menu2 = UIMenu(title: "", children: nutriArrayCount?.count == 0 ? [shareAction, cookAction, unsaveAction] : [shareAction, cookAction, nutriFactAction, unsaveAction])
            let menu3 = UIMenu(title: "", children: [shareAction, unsaveAction] )
            let menu4 = UIMenu(title: "", children: [shareAction, cookAction, nutriFactAction, unsaveAction])

            var mainMenu = UIMenu()

            // Disable menu item if needed for better UX
            if prepArray?.count == 0 {
                print("menu1")
                mainMenu = menu1
            } else if nutriArrayCount?.count == 0 {
                print("menu2")
                mainMenu = menu2
            } else if prepArray?.count == 0 && nutriArrayCount?.count == 0 {
                print("menu3")
                mainMenu = menu3
            } else {
                print("menu4")
                mainMenu = menu4
            }
            print("mainMenu")
            
            // Create a UIMenu with all the actions as children
            return mainMenu
        }
    }
    
    @objc func backBtnPressed() {
        print("123")
    }
    
}

    // MARK: - UIContextMenuInteraction Extension
//extension FavoriteVC: UIContextMenuInteractionDelegate {
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
//
//            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
//                // do whatever actions you want to perform...
//            }
//
//            let viewAction = UIAction(title: "View Recipe", image: UIImage(systemName: "eye")) { _ in
//                // do whatever actions you want to perform...
//            }
//
//            let unsaveAction = UIAction(title: "Unsave", image: UIImage(systemName: "heart.slash"), attributes: .destructive) { _ in
//                // do whatever actions you want to perform...
//
//                guard let indexPath = self.collectionView.indexPathForView(self.collectionView) else { return }
//
//                //                var deleteNeededIndexPaths: [IndexPath] = []
////                for (key, value) in self.selectedIndexPathDic {
////                    if value {
////                        deleteNeededIndexPaths.append(key)
////                    }
////                }
////
////                for i in indexPath.sorted(by: { $0.item > $1.item }) {
//                    /// removes item from CoreData
//                self.viewModel.deleteItem(name: self.favoritedPostArray[indexPath.item].name)
//                    self.favoritedPostArray.remove(at: indexPath.item)
////                }
//
//                self.collectionView.deleteItems(at: [indexPath])
//                self.selectedIndexPathDic.removeAll()
//                print(indexPath)
//
//            }
//
//            return UIMenu(title: "", children: [shareAction, viewAction, unsaveAction])
//        }
//
//    }
//
//}
//
//







//extension UICollectionView {
//
//    func deselectAllItems(animated: Bool) {
//        guard let selectedItems = indexPathsForSelectedItems else { return }
//        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
//    }
//}

//
//func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//      return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
//
//          // Create an action for sharing
//          let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
//              // do whatever actions you want to perform...
//          }
//
//          let editAction = UIAction(title: "View Recipe", image: UIImage(systemName: "eye")) { _ in
//              // do whatever actions you want to perform...
//          }
//
//          let unsaveAction = UIAction(title: "Unsave", image: UIImage(systemName: "heart.slash"), attributes: .destructive) { _ in
//              // do whatever actions you want to perform...
//
//          }
//
//          // Create a UIMenu with all the actions as children
//          return UIMenu(title: "", children: [shareAction, editAction, unsaveAction])
//      }
//  }

