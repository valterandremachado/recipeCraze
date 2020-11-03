//
//  CategoryDetailsCell.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/8/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import ShimmerSwift

class CategoryDetailsCell: UICollectionViewCell {
    
    let recipeImage = UIImage(named: "fast food-food")?.withTintColor(.white)

    // MARK: - Properties
    lazy var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
//        iv.image = recipeImage
        return iv
    }()
    
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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .systemPink
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categoryViewModel: CategoryViewModel! {
        
        didSet {
            let biggerUrlImageSize = "https://spoonacular.com/recipeImages/\(self.categoryViewModel.id)-636x393.jpg"
            /// Load ulr image to UIImage variable
            UrlImageLoader.sharedInstance.imageForUrl(urlString: biggerUrlImageSize, completionHandler: { (image, url) in
                if image != nil {
                    self.categoryImageView.image = image
                }
            })
        }
        
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        [categoryImageView, shimmerView].forEach({contentView.addSubview($0)})
                
        categoryImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        shimmerView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
    }
    
    // MARK: - Selectors
    
}
