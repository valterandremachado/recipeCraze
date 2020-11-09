//
//  HomeCell.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import ShimmerSwift

final class HomeCell: UICollectionViewCell {
    
    // MARK: - Properties
    var linkDelegate: HomeVCDelegate?

    let recipeImage = UIImage(named: "food.jpg")
        
    lazy var recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        //iv.image = recipeImage
        return iv
    }()
    
    lazy var ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "4.5"
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.backgroundColor = .systemPink
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 10
        return lbl
    }()
    
    lazy var reviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.text = "23 reviews"
        lbl.layer.shadowColor = .init(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
//        btn.setTitle("Save", for: .normal)
//        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .black, scale: .large)

        btn.setImage(UIImage(systemName: "heart"), for: .normal)
//        btn.setImage(UIImage(systemName: "heart.fill"), for: .selected)
//        btn.backgroundColor = .yellow
        btn.tintColor = .systemPink
//        btn.semanticContentAttribute = .forceRightToLeft
//        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 25, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: (bounds.width - 20), left: 0, bottom: 0, right: (bounds.width - 20))

        btn.addTarget(self, action: #selector(saveBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var recipeNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false

        lbl.text = "Vigan Salad"
        lbl.numberOfLines = 0 // 0 = as many lines as the label needs
        lbl.frame.origin.x = 32
        lbl.frame.origin.y = 32
        lbl.frame.size.width = self.bounds.width - 64
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var recipeOwnerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "by Salt Man"
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var recipeOwnerImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = recipeImage
        return iv
    }()
    
    lazy var stackView1: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ratingLabel, reviewLabel])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .gray)
        return sv
    }()
    
    lazy var stackView2: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [recipeOwnerImageView, recipeOwnerLabel])
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .yellow)
        return sv
    }()
    
    lazy var stackView3: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [recipeNameLabel, stackView2])
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillProportionally
//        sv.addBackground(color: .blue)
        return sv
    }()
    
    lazy var transparentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
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

    
    // MARK: - Populates cells with data coming from ViewModel
    var recipeViewModel: RecipeViewModel2! {
        didSet {
            
            /// Load ulr image to UIImage variable
            UrlImageLoader.sharedInstance.imageForUrl(urlString: self.recipeViewModel.image, completionHandler: { (image, url) in
                if image != nil {
                    self.recipeImageView.image = image
                }
            })
            /// Load ulr image to UIImage variable
            UrlImageLoader.sharedInstance.imageForUrl(urlString: self.recipeViewModel.ownerPic, completionHandler: { (image, url) in
                if image != nil {
                    self.recipeOwnerImageView.image = image
                }
            })
            
            self.recipeNameLabel.text = recipeViewModel.name
            self.reviewLabel.text = "\(recipeViewModel.review) reviews"
            self.ratingLabel.text = String(format:"%.1f", recipeViewModel.rating)
            self.recipeOwnerLabel.text = "by \(recipeViewModel.ownerName)"
            
            /// recipeViewModels
//            self.recipeOwnerImageView.image = UIImage(imageLiteralResourceName: recipeViewModel.image)
//            self.recipeNameLabel.text = recipeViewModel.name
//            self.reviewLabel.text = "\(recipeViewModel.review) reviews"
            
           

//                / Threading: for a better UX
//            DispatchQueue.global(qos: .userInteractive).async {
//                let image = self.recipeViewModel.image
//                DispatchQueue.main.async {
//                    self.recipeImageView.image = UIImage(imageLiteralResourceName: image)
//                }
//            }
//
           
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        backgroundColor = .yellow
        setupViews()
//        heartbeat()
    }
    
    
    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.recipeOwnerImageView.layer.cornerRadius = self.recipeOwnerImageView.frame.size.height/2
//            self.recipeImageView.contentMode = .scaleAspectFill
//            self.recipeImageView.clipsToBounds = true
//            self.recipeImageView.layer.masksToBounds = true
        }
//        saveButton.tintColor = .blue
    }
    
    // MARK: - Functions
//    func setupShimmerAnimation(){
//        if recipeViewModels2.isEmpty != true {
//            shimmerView.isShimmering = false
//            viewForShimmer.fadeOut()
//        } else {
//            viewForShimmer.fadeIn()
//            shimmerView.contentView = viewForShimmer
//            shimmerView.isShimmering = true
//        }
//    }
    
    fileprivate func setupViews(){
        [recipeImageView, transparentView, shimmerView].forEach({addSubview($0)})
        [stackView1, saveButton, stackView3].forEach({transparentView.addSubview($0)})
        self.bringSubviewToFront(shimmerView)
        
        recipeImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        transparentView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)

        ratingLabel.withWidth(45)
        stackView1.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0))
        
        saveButton.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20))
        saveButton.withHeight(40)
        saveButton.withWidth(40)
//        saveButton.backgroundColor = .black
        
        shimmerView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        recipeOwnerImageView.withWidth(30)
        recipeOwnerImageView.withHeight(30)
        
        stackView3.withWidth(300)
        stackView3.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0))
    }
    
    func heartbeat(){
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.12
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.8

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]

        saveButton.layer.add(animationGroup, forKey: "pulse")
    }
    
//    lazy var popUpWindow: PopUpWindow = {
//        let view = PopUpWindow()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
//        view.delegate = self
//        return view
//    }()
//
//    func handleDismissal() {
//           print("123")
//    }
    
    //     MARK: - Selectors
    @objc private func saveBtnPressed(_ sender: UIButton){
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        }, completion: nil)
        
//        let imageSaved = UIImage(systemName: "heart.fill")
//        let imageUnsaved = UIImage(systemName: "heart")

        linkDelegate?.saveRecipeLinkMethod(cell: self, button: sender)

        print("123 homeCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


