//
//  CategoryVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
    var categoryArray = ["Dinner", "Lunch", "Breakfast", "Bakes", "Salad", "Soup", "Snack", "Vegetarian", "Vegan", "Appetizer"]
    private let cellID = "cellID"
        
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 3
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: cellID)
        return cv
    }()
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        setupViews()
        setupNavBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading view.
    }
    
    // MARK: - Methods
    fileprivate func setupNavBar(){
        guard let nav = navigationController?.navigationBar else { return }
        nav.prefersLargeTitles = true
//        nav.hideNavBarSeperator()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Categories"
//        nav.tintColor = .white
//        title = "Categories"

    }
    
    fileprivate func setupViews(){
        [collectionView].forEach({view.addSubview($0)})
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    // MARK: - Selectors


}

    // MARK: - CollectionView Extension
extension CategoryVC: CollectionDataSourceAndDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CategoryCell
        let indexPathForCategories = categoryArray[indexPath.item]
        
        //This creates the shadows and modifies the cards a little bit
//        cell.contentView.layer.cornerRadius = 4.0
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = false
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        cell.layer.shadowRadius = 4.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.categoryArray = indexPathForCategories
       
 
//        DispatchQueue.main.async {
//            cell.categoryImageView.image = UIImage(imageLiteralResourceName: indexPathForCategories)
//        }
//        cell.titleLabel.text = indexPathForCategories
//        cell.clipsToBounds = true
//        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let viewHeight = view.frame.height
        let viewWidth = view.frame.width
        let size = CGSize(width: viewWidth - 10, height: 150)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // give space top left bottom and right for cells
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryDetails = CategoryDetailsVC()
        categoryDetails.mealType = "\(categoryArray[indexPath.item])"
        categoryDetails.navigationItem.title = categoryArray[indexPath.item]
        navigationController?.pushViewController(categoryDetails, animated: true)
    }
    
    
}






//extension CategoryVC: TableViewDataSourceAndDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categoryArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CategoryCell2
//               let indexPathForCategories = categoryArray[indexPath.item]
//        cell.textLabel?.text = indexPathForCategories
//        cell.backgroundColor = .clear
//        cell.textLabel?.textColor = .white
//                cell.textLabel?.textAlignment = .center
//        //        cell.textLabel?.font = lbl.font.withSize(40)
//                cell.textLabel?.font = .boldSystemFont(ofSize: 35)
//
//               return cell
//    }
//
//
//}

    
//    lazy var tableView: UITableView = {
//            let tv = UITableView()
//            tv.translatesAutoresizingMaskIntoConstraints = false
////            tv.backgroundColor = .clear
//        DispatchQueue.main.async {
//                          tv.addGradientBackground(firstColor: .systemPink, secondColor: .black)
//                      }
//            //        tv.separatorColor = .gray
//            tv.isScrollEnabled = true
//    //        tv.isUserInteractionEnabled = false
//            tv.allowsSelection = false
//            tv.tableFooterView = UIView()
//            tv.delegate = self
//            tv.dataSource = self
//            tv.register(CategoryCell2.self, forCellReuseIdentifier: cellID)
//            return tv
//        }()
