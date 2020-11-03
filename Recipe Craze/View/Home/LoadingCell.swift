//
//  LoadingCell.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 6/3/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    
    // MARK: - Properties
    var indicator: ProgressIndicator!

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .red
        setupActivityIndicator()
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        [indicator].forEach({contentView.addSubview($0)})
        
        let screenWidth = UIScreen.main.bounds.size.width

        indicator.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: screenWidth/2 - 30, bottom: 0, right: screenWidth/2 - 30))
    }
    
    fileprivate func setupActivityIndicator(){
        // Setting up activity indicator
        indicator = ProgressIndicator(inview: self,loadingViewColor: UIColor.clear, indicatorColor: UIColor.black, msg: "")
    }
    
}
