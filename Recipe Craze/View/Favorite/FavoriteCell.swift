//
//  FavoriteCell.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/8/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import CoreData
import ShimmerSwift

class FavoriteCell: UICollectionViewCell {
    
    var favoritedPostArray = [FavoritedRecipeToCD]()

    // MARK: - Properties
    lazy var favoritedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //           iv.image = recipeImage
        return iv
    }()
    
    lazy var highlightIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        view.isHidden = true
        return view
    }()
    
    lazy var selectIndicator: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        iv.isHidden = true
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = "Dinner"
        lbl.textColor = .white
        //        lbl.textAlignment = .center
        //        lbl.font = lbl.font.withSize(40)
        lbl.font = .boldSystemFont(ofSize: 25)
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
//        lbl.layer.cornerRadius = 10
        return lbl
    }()
      
    // MARK: - Init
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected
        }
    }
    
    lazy var shimmerView: ShimmeringView = {
        let shimmer = ShimmeringView()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        return shimmer
    }()
    
    lazy var viewForShimmer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "shimmerAppearance")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "backgroundAppearance")
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        contentView.addSubview(favoritedImageView)
        
        [selectIndicator, highlightIndicator, shimmerView].forEach({favoritedImageView.addSubview($0)})
        favoritedImageView.bringSubviewToFront(selectIndicator)
        self.bringSubviewToFront(shimmerView)

        selectIndicator.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5))
        selectIndicator.withWidth(28)
        selectIndicator.withHeight(28)
        
        highlightIndicator.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        favoritedImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        shimmerView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)

    }
    
    // MARK: - Selectors

}
