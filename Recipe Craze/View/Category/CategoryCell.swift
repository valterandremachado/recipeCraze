//
//  CategoryCell.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/8/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    //    var categoryArray = ["Dinner", "Lunch", "Breakfast", "Bakes", "Salad", "Soup", "Vegetarian", "Vegan", "Appetizer"]
    
    // MARK: - Properties
    let recipeImage = UIImage(named: "fast food-food")?.withTintColor(.white)
    
    lazy var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        //        iv.image = recipeImage
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = "Dinner"
        lbl.textColor = .systemPink
        //        lbl.textAlignment = .center
        //        lbl.font = lbl.font.withSize(40)
        lbl.font = .boldSystemFont(ofSize: 35)
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 10
        return lbl
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [categoryImageView, titleLabel])
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .center
        sv.distribution = .fillProportionally
        return sv
    }()
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "backgroundAppearance")
        return view
    }()
    
    var categoryArray: String! {
        didSet {
            DispatchQueue.main.async { [self] in 
                self.categoryImageView.image = UIImage(named: categoryArray)
                self.titleLabel.text = categoryArray //.uppercased()
            }
            
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        //        backgroundColor = .systemPink
        DispatchQueue.main.async { [self] in
            transparentFading()
        }
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    fileprivate func transparentFading() {
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 1.23, y: 0)
        mask.endPoint = CGPoint(x: 0, y: 0)
        guard let whiteColor = UIColor(named: "backgroundAppearance") else { return }
        mask.colors = [whiteColor.withAlphaComponent(0.0).cgColor,
                       whiteColor.withAlphaComponent(1.0),
                       whiteColor.withAlphaComponent(1.0).cgColor]
        mask.locations = [NSNumber(value: 0.0),
                          NSNumber(value: 0.2),
                          NSNumber(value: 1.0)]
        mask.frame = view.bounds
        view.layer.mask = mask
    }
    
    fileprivate func setupViews(){
        [categoryImageView, titleLabel].forEach({contentView.addSubview($0)})
        categoryImageView.addSubview(view)
        contentView.bringSubviewToFront(titleLabel)
        
        categoryImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        view.anchor(top: categoryImageView.topAnchor, leading: categoryImageView.leadingAnchor, bottom: categoryImageView.bottomAnchor, trailing: categoryImageView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (UIScreen.main.bounds.width/3) - 20), size: CGSize(width: 0, height: 0))
        
        
        titleLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: 20, right: 0))
    }
    
    // MARK: - Selectors
    
}

