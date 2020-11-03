//
//  CategoryCell.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/8/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit



//class CategoryCell2: UITableViewCell {
//
//      lazy var titleLabel2: UILabel = {
//            let lbl = UILabel()
//            lbl.translatesAutoresizingMaskIntoConstraints = false
//            lbl.text = "Dinner"
//            lbl.textColor = .white
//    //        lbl.textAlignment = .center
//    //        lbl.font = lbl.font.withSize(40)
//            lbl.font = .boldSystemFont(ofSize: 35)
//            lbl.clipsToBounds = true
//            lbl.layer.cornerRadius = 10
//            return lbl
//        }()
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
////        setupViews()
//    }
//    
//   
//    // MARK: - Methods
//        fileprivate func setupViews(){
//            [titleLabel2].forEach({contentView.addSubview($0)})
//            
//    //        categoryImageView.addSubview(titleLabel)
//            
//    //        categoryImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
//            
//            titleLabel2.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }
//}


class CategoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    let recipeImage = UIImage(named: "fast food-food")?.withTintColor(.white)
        
    lazy var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.image = recipeImage
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Dinner"
        lbl.textColor = .white
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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemPink
        DispatchQueue.main.async {
            self.addGradientBackground(firstColor: .systemPink, secondColor: .black)
        }
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        [mainStackView].forEach({contentView.addSubview($0)})
                
//        categoryImageView.withHeight(20)
        mainStackView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
//        titleLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 30, bottom: 15, right: 0))
    }
    
    // MARK: - Selectors

}
