//
//  SearchVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {
    let tempArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
                     "13", "14", "15", "16", "16", "17", "18", "19", "22", "23", "24", "25"]
    /// ViewModel (data)
    var recipeViewModels = [RecipeViewModel2]()
    var filteredData: [RecipeViewModel2] = []
    //    var data = viewModel.recipePostArray
    var isSearching = false
    var buttonStates = [Bool]()

    
    private let searchCellID = "cellID"
    private let headerCellID = "headerCellID"
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        //        layout.estimatedItemSize = .zero
        
        // Sticky header
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(SearchCell.self, forCellWithReuseIdentifier: searchCellID)
        //        cv.register(OuterSearchHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellID)
        
        return cv
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        sb.placeholder = "Search"
        sb.tintColor = .systemPink
        //sb.backgroundColor = .white
        sb.delegate = self
        return sb
    }()
    
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
        //        setStatusBar(color: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Methods
    //    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.collectionView.resignFirstResponder()
    //    }
    
    fileprivate func fetchData() {
        
        Service2.shared.fetchRecipes { (recipes, err) in
            if let err = err {
                print("Failed to fetch recipes:", err)
                return
            }
            
            let data = recipes?.map({ return RecipeViewModel2(recipe: $0)}) ?? []
            self.recipeViewModels.append(contentsOf: data)
            /// Give default state to the buttons based on the amount of data retrieved
            for _ in 0..<(self.recipeViewModels.count) {
                self.buttonStates.append(false)
                // in my case, all buttons are off, but be sure to implement logic here
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func setupViews(){
        //        let customView = UIView()
        
        [collectionView].forEach({view.addSubview($0)})
        
        //        customView.backgroundColor = .white
        //        NSLayoutConstraint.activate([
        //            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //        ])
        //        customView.withWidth(300)
        
        //        customView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func setupNavBar(){
        
        //        self.navigationController?.hidesBarsOnSwipe = true
        
        guard let nav = navigationController?.navigationBar else { return }
        //        nav.prefersLargeTitles = true
        nav.hideNavBarSeperator()
        //        navigationItem.largeTitleDisplayMode = .automatic
        
        let rightNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        
        isSearching = false
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        searchBar.text = searchText.lowercased()
        if searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            //            print("isEmpty")
            collectionView.isHidden = true
            collectionView.reloadData()
        } else {
            collectionView.isHidden = false
            collectionView.reloadData()
        }
        
        //        let input = searchText
        //        print(input)
        //        let data = viewModel.recipePostArray
        //
        //        data.forEach { recipes in
        //            filteredData = [recipes.image]
        //
        //            if searchText.isEmpty != true {
        //                filteredData = filteredData.filter({ $0.contains(searchText) })
        //                print(filteredData)
        //            }
        //            isSearching = true
        //            collectionView.reloadData()
        //        }
        
        filteredData = recipeViewModels
        if searchText.isEmpty == false {
            filteredData = recipeViewModels.filter({ $0.name.contains(searchText) })
            print(filteredData)
            isSearching = true
            collectionView.reloadData()
        }
        //        data.forEach { recipes in
        //            let arrayOfImages = [recipes.image]
        //            filteredData = arrayOfImages.filter({$0.prefix(searchText.count) == searchText})
        //            print(filteredData)
        //            isSearching = true
        //            collectionView.reloadData()
        //        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
    // MARK: - Selectors
    
} // End if of SearchVC

// MARK: - CollectionView Extension
extension SearchVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count //? (tempArray.count) : (filteredData.count)
        }
        return recipeViewModels.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellID, for: indexPath) as! SearchCell
        
        
        DispatchQueue.main.async { [self] in
            //            let searchedData = self.data[indexPath.item].image
            
            //            if filteredData.isEmpty != true {
            //                collectionView.isUserInteractionEnabled = true
            //
            //                cell.shimmerView.isShimmering = false
            //                // fadeOut viewForShimmer
            //                cell.viewForShimmer.fadeOut()
            //                cell.searchImageView.fadeIn()
            
            if self.isSearching == true {
                let searchedData = self.filteredData[indexPath.item].image
                /// Load ulr image to UIImage variable
                UrlImageLoader.sharedInstance.imageForUrl(urlString: searchedData, completionHandler: { (image, url) in
                    if image != nil {
                        cell.searchImageView.image = image
                    }
                })
                
                cell.searchImageView.isHidden = false
            } else {
                cell.searchImageView.image = nil
                cell.searchImageView.isHidden = true
            }
            //            } else {
            //                // disable userInteraction while shimmer animation is running for a good UX
            //                collectionView.isUserInteractionEnabled = false
            //                // fadeIn viewForShimmer
            //                cell.viewForShimmer.fadeIn()
            //                cell.searchImageView.fadeOut()
            //                // add the customView to shimmerContent
            //                cell.shimmerView.contentView = cell.viewForShimmer
            //                cell.shimmerView.isShimmering = true
            //            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = HomeDetailVC()
        
        let indexedFilteredData = self.filteredData[indexPath.item]
        print("tryout: \(indexPath.item)")
        detailVC.recipeID = indexedFilteredData.id
        detailVC.recipeNameLabel.text = indexedFilteredData.name
//        detailVC.recipeImageView.image = UIImage(imageLiteralResourceName: indexedRecipe.image)
//        print("arrayCount: \(indexedRecipe.nutrientArray?.count)")

        detailVC.buttonStatesHomeVC = buttonStates
        detailVC.indexPathHomeVC = indexPath
        detailVC.recipeItemIndexPath = indexedFilteredData
        detailVC.title = "Explore".uppercased()
//        detailVC.indexedIngredArray = indexedRecipe.ingredientArray ?? []
            
        UrlImageLoader.sharedInstance.imageForUrl(urlString: indexedFilteredData.image, completionHandler: { (image, url) in
            if image != nil {
                detailVC.recipeImageView.image = image
            }
        })

        detailVC.durationLabel.text = indexedFilteredData.duration
        detailVC.servingsLbl = indexedFilteredData.numberOfServings
        
        /// Prevent app from crash because of nil/empty object coming from the json array
        if !indexedFilteredData.nutrientArray!.isEmpty {
            /// Prevent app from crash because of missing object in json array
            if indexedFilteredData.nutrientArray!.contains(where: { $0.nutrientName == "FAT" }) {
                print("FAT exists in the array")
                detailVC.calLabel.text = String(format:"%.0f", indexedFilteredData.nutrientArray![0].nutrientAmount) + " kcal"
                detailVC.fatsLabel.text = String(format:"%.0f", indexedFilteredData.nutrientArray![13].nutrientAmount) + " g"
            } else {
                print("FAT does not exists in the array")
                detailVC.calLabel.text = String(format:"%.0f", indexedFilteredData.nutrientArray![1].nutrientAmount) + " kcal"
                detailVC.fatsLabel.text = String(format:"%.0f", indexedFilteredData.nutrientArray![2].nutrientAmount) + " g"
            }
            print("indexedRecipe: \(indexPath.item)")

        } else {
            detailVC.calLabel.text = "N/A"
            detailVC.fatsLabel.text = "N/A"
        }

        detailVC.nutritionArray = indexedFilteredData.nutrientArray!
        detailVC.ingredientArray = indexedFilteredData.ingredientArray!
        detailVC.preparationSteps = indexedFilteredData.preparationStepsArray
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 3.0
        
        /// changing sizeForItem when user switches through the segnment
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .zero
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow))
        
        var sizeW = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        var sizeH = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        if indexPath.item % 4 == 0 {
            sizeW += sizeW*2
            sizeH += sizeH
        }
        
        return CGSize(width: sizeW - 1, height: sizeH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // give space top left bottom and right for cells
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    /// header height
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSize(width: view.frame.width, height: 50)
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
    //        String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
    //            headerCellID, for: indexPath) as! OuterSearchHeaderCell
    //
    //        return header
    //    }
    
    
}
