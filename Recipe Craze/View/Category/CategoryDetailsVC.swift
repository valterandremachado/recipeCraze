//
//  CategoryDetailsVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/8/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

class CategoryDetailsVC: UIViewController {
    
    private let categoryCellID = "categoryCellID"
    
    var categoryViewModel = [CategoryViewModel]()
    var buttonStates = [Bool]()
    
    private var isFetching = false
    private let loadingCellID = "loadingID"
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryDetailsCell.self, forCellWithReuseIdentifier: categoryCellID)
        cv.register(LoadingCell.self, forCellWithReuseIdentifier: loadingCellID)
        return cv
    }()
    
    lazy var mealType = ""
    lazy var fetchingLimitNumber = 100
    lazy var fetchMore = 30
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        setupViews()
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading view.
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nav = navigationController?.navigationBar else { return }
        nav.titleTextAttributes = [.foregroundColor: UIColor(named: "labelAppearance")!]
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    // MARK: - Methods
    fileprivate func fetchData() {
        
        CategoryService.shared.fetchRecipes(mealType: mealType, limit: fetchingLimitNumber) { (recipes, err) in
            if let err = err {
                print("Failed to fetch recipes:", err)
                return
            }
            
            print("mealType: \(self.mealType)")
            
            let data = recipes?.map({ return CategoryViewModel(recipeModel: $0)}) ?? []
            self.categoryViewModel.append(contentsOf: data)
            for _ in 0..<(self.categoryViewModel.count) {
                self.buttonStates.append(false)
                // in my case, all buttons are off, but be sure to implement logic here
            }
//            print("beginBatchFetch!: \(self.categoryViewModel.count)")
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func setupViews(){
        [collectionView].forEach({view.addSubview($0)})
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupNavBar(){
        guard let nav = navigationController?.navigationBar else { return }
        nav.tintColor = .systemPink
    }
    
    // MARK: - Selectors
    
}


// MARK: - CollectionView Extension
extension CategoryDetailsVC: CollectionDataSourceAndDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            //            recipeViewModels2.isEmpty ? (0) : (recipeViewModels2.count)
            return categoryViewModel.isEmpty ? (20) : (categoryViewModel.count)
        } else if section == 1 && !isFetching {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellID, for: indexPath) as! CategoryDetailsCell
        let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCellID, for: indexPath) as! LoadingCell
        
        // return loading collectionViewCell
        if indexPath.section == 1 {
            loadingCell.indicator.start()
            return loadingCell
        }
        
        if categoryViewModel.isEmpty != true {
            collectionView.isUserInteractionEnabled = true
            
            cell.shimmerView.isShimmering = false
            // fadeOut viewForShimmer
            cell.viewForShimmer.fadeOut()
            // fadeIut views to give a clean shimmer animation
            cell.categoryImageView.fadeIn()
            cell.shimmerView.isHidden = true
            
            let indexedViewModel = categoryViewModel[indexPath.item]
            cell.categoryViewModel = indexedViewModel
        } else {
            // disable userInteraction while shimmer animation is running for a good UX
            collectionView.isUserInteractionEnabled = false
            // fadeIn viewForShimmer
            cell.viewForShimmer.fadeIn()
            // fadeOut views to give a clean shimmer animation
            cell.categoryImageView.fadeOut()
            // add the customView to shimmerContent
            cell.shimmerView.contentView = cell.viewForShimmer
            cell.shimmerView.isShimmering = true
            cell.shimmerView.shimmerSpeed = 100
            cell.shimmerView.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = HomeDetailVC()
        let indexedViewModel = categoryViewModel[indexPath.item]
        
        detailsVC.categIsVisible = self.isVisible
        detailsVC.recipeID = "\(indexedViewModel.id)"
        detailsVC.recipeNameLabel.text = indexedViewModel.name
        detailsVC.durationLabel.text = "\(indexedViewModel.duration) min"
        detailsVC.servingsLbl = indexedViewModel.numberOfServings
        detailsVC.title = mealType.uppercased()
        UrlImageLoader.sharedInstance.imageForUrl(urlString: indexedViewModel.image, completionHandler: { (image, url) in
            if image != nil { detailsVC.recipeImageView.image = image }
        })
        
        if !indexedViewModel.nutritionArray.isEmpty {
            detailsVC.calLabel.text = String(format:"%.0f", indexedViewModel.nutritionArray[0].amount) + " kcal"
            detailsVC.fatsLabel.text = String(format:"%.0f", indexedViewModel.nutritionArray[1].amount) + " g"
        } else {
            detailsVC.calLabel.text = "N/A"
            detailsVC.fatsLabel.text = "N/A"
        }
        
        var tempStepsArray = [String]()
        indexedViewModel.preparationStepsArray.forEach { (stepArray) in tempStepsArray.append(contentsOf: [stepArray.step])}
        
        detailsVC.preparationSteps = tempStepsArray
        detailsVC.categNutritionArray = indexedViewModel.nutritionArray
        detailsVC.categIngredientArray = indexedViewModel.ingredientArray
        
        // IndexPath handlers
        detailsVC.buttonStatesHomeVC = buttonStates
        detailsVC.indexPathHomeVC = indexPath
        detailsVC.categItemIndexPath = indexedViewModel
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width - 20, height: 30)
        }
        
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
        if section == 1 {
            return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let positionY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if  (positionY > (contentHeight - scrollView.frame.height*1.1) + 5) && (positionY != 0.0) {
            print("fetchingLimitNumber: \(fetchingLimitNumber)")
//            fetchingLimitNumber != 100 ? (self.isFetching = true) : (self.isFetching = false)
//
//            if isFetching {
//                beginFetchMoreData()
//            }
            
        }
        
    }
    
    func beginFetchMoreData(){
        isFetching = true
               
        print("fetchingLimitNumber: \(fetchingLimitNumber)")
        
            fetchingLimitNumber == 90 ? (fetchingLimitNumber += 10) : (fetchingLimitNumber += fetchMore)
            print("fetchingLimitNumber: \(fetchingLimitNumber)")

            CategoryService.shared.fetchRecipes(mealType: mealType, limit: fetchingLimitNumber) { (recipes, err) in
                if let err = err {
                    print("Failed to fetch recipes:", err)
                    return
                }
                let newFetchedData = recipes?.map({ return CategoryViewModel(recipeModel: $0)}) ?? []
                self.categoryViewModel.append(contentsOf: newFetchedData)
                // if newDataArray isn't populated yet isFetching is true
                /// Give default state to the buttons based on the amount of data retrieved
                for _ in 0..<(self.categoryViewModel.count) {
                    self.buttonStates.append(false)
                    // in my case, all buttons are off, but be sure to implement logic here
                }
                self.isFetching = false
                print("fetchingLimitNumber: \(self.isFetching)")
                print("beginBatchFetch!: \(self.categoryViewModel.count)")
                self.collectionView.reloadData()
            }
        
    }
}

