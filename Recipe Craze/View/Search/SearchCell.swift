//
//  SearchCell.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/8/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//
import UIKit
import ShimmerSwift

class SearchCell: UICollectionViewCell {
        
    // MARK: - Properties
    lazy var searchImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        //           iv.image = recipeImage
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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "backgroundApperance")
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
//        contentView.addSubview(searchImageView)
        [searchImageView, shimmerView].forEach({addSubview($0)})
        self.bringSubviewToFront(shimmerView)

        [titleLabel].forEach({searchImageView.addSubview($0)})
        titleLabel.isHidden = true
        
        searchImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        titleLabel.anchor(top: searchImageView.topAnchor, leading: searchImageView.leadingAnchor, bottom: searchImageView.bottomAnchor, trailing: searchImageView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        shimmerView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)

    }
    
    // MARK: - Selectors
    
}
