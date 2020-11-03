//
//  OnScreenStepsVC.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 6/14/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
//import PaperOnboarding
//import SwiftyOnboard

class OnScreenStepsVC: UIViewController {
    
    var recipeViewModels = [RecipeViewModel2]()
    lazy var preparationStepsArray = recipeViewModels.first?.preparationStepsArray
    let imageArray = ["1", "2", "3", "4", "5", "6", "7", "8",
                      "9", "10", "11", "12", "13", "14", "15",
                      "16", "17", "18", "20", "21"].shuffled2()
    
//    var imageArray: [String] = ["fridge", "cuttingBoard", "cooking"]
//    var titleArray: [String] = ["Prepare Your Ingredients", "Slice Potatoes", "Pre-heat Frying Pan"]
//    var subTitleArray: [String] = ["Preparation is the key. Make sure to get all your ingredients ready: 3 pounds riblets (pork), 2 cups brown sugar (lightly packed), 2 teaspoons dry mustard, 1 tablespoon chili powder, 1/4 cup Worcestershire sauce, 1/2 cup white vinegar, 1 1/2 cups ketchup, 1 cup water, 1/4 teaspoon salt, 1/2 teaspoon ground black pepper", "All confessions sent are\n anonymous. Your friends will only\n know that it came from one of\n their facebook friends.", "Be nice to your friends.\n Send them confessions that\n will make them smile :)"]
    
    // MARK: - Properties
    lazy var onboardingView: SwiftyOnboard = {
        let ob = SwiftyOnboard(frame: view.frame)
        ob.translatesAutoresizingMaskIntoConstraints = false
        //        ob.backgroundColor = .red
        ob.dataSource = self
        
        return ob
    }()
    
    lazy var foodNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Salad with Bread"
        //        lbl.font = .systemFont(ofSize: 20)
        lbl.font = .boldSystemFont(ofSize: 23)
        lbl.textColor = .systemPink
        return lbl
    }()
    
    var totalSteps = 0
    var counterSteps = 1
    
    lazy var stepCounterLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        //        lbl.text = "Step \(1) / " + totalStepsLbl.text!
        return lbl
    }()
    
    lazy var servingsLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 18)
        //        lbl.text = "Step \(1) / " + totalStepsLbl.text!
        lbl.textColor = .systemPink
        return lbl
    }()
    
    lazy var totalStepsLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        totalSteps = preparationStepsArray!.count
        lbl.text = "\(totalSteps)"
        return lbl
    }()
    
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .close)
        btn.translatesAutoresizingMaskIntoConstraints = false
        //        btn.sizeToFit()
        //        btn.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var illustrationImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        return iv
    }()
    
    lazy var stepTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Prepare Your Ingredients"
        lbl.textAlignment = .center
        //        lbl.font = .systemFont(ofSize: 50)
        
        lbl.numberOfLines = 0 // 0 = as many lines as the label needs
        lbl.frame.origin.x = 32
        lbl.frame.origin.y = 32
        lbl.frame.size.width = self.view.frame.width - 64
        lbl.font = UIFont.boldSystemFont(ofSize: 50)
        
        lbl.textColor = .systemPink
        return lbl
    }()
    
    lazy var stepDescriptionLbl: UITextView = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 18)
        tf.text = "Preparation is the key. Make sure to get all your ingredients ready: 3 pounds riblets (pork), 2 cups brown sugar (lightly packed), 2 teaspoons dry mustard, 1 tablespoon chili powder, 1/4 cup Worcestershire sauce, 1/2 cup white vinegar, 1 1/2 cups ketchup, 1 cup water, 1/4 teaspoon salt, 1/2 teaspoon ground black pepper"
        tf.isEditable = false
        tf.isScrollEnabled = false
        tf.textAlignment = .center
        return tf
    }()
    
    lazy var nextStepBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Next", for: .normal)
        //        btn.sizeToFit()
        //        btn.contentMode = .scaleAspectFill
        return btn
    }()
    
    lazy var previousStepBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Previous", for: .normal)
        //        btn.sizeToFit()
        //        btn.contentMode = .scaleAspectFill
        return btn
    }()
    
    lazy var topStackViewMain: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        sv.axis = .vertical
        sv.spacing = 2
        sv.distribution = .fillEqually
        sv.alignment = .fill
//                sv.addBackground(color: .yellow)
        return sv
    }()
    
    //    lazy var bottomStackViewMain: UIStackView = {
    //        let sv = UIStackView(arrangedSubviews: [illustrationImage, stepTitleLbl, stepDescriptionLbl])
    //        sv.axis = .vertical
    //        sv.spacing = -15
    //        sv.distribution = .fillEqually
    //        sv.alignment = .fill
    //        //        sv.addBackground(color: .yellow)
    //        return sv
    //    }()
    
    //    lazy var stepBtnsStackView: UIStackView = {
    //        let sv = UIStackView(arrangedSubviews: [previousStepBtn, nextStepBtn])
    //        sv.axis = .horizontal
    //        sv.spacing = 0
    //        sv.distribution = .fillEqually
    //        sv.alignment = .fill
    ////        sv.addBackground(color: .yellow)
    //        return sv
    //    }()
    //
    lazy var topStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [foodNameLbl, closeBtn])
        sv.axis = .horizontal
        //        sv.alignment = .fill
        //        sv.spacing = 20
        sv.distribution = .fillProportionally
        //        sv.addBackground(color: .blue)
        return sv
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [stepCounterLbl, servingsLbl])
        sv.axis = .horizontal
//        sv.alignment = .center
        //        sv.spacing = 20
        sv.distribution = .fill
        //        sv.addBackground(color: .red)
        return sv
    }()
    
    // MARK: - Init
    override func viewDidLoad() {
        setupViews()
        view.backgroundColor = UIColor(named: "backgroundAppearance")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLabel()
    }
    
    // MARK: - Functions/Methods
    fileprivate func setupViews() {
        [topStackViewMain, onboardingView].forEach({view.addSubview($0)})
        view.sendSubviewToBack(onboardingView)
        topStackViewMain.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 25, bottom: 0, right: 25), size: CGSize(width: 0, height: 0))

        closeBtn.withSize(CGSize(width: 30, height: 30))
        
        onboardingView.anchor(top: topStackView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: -(view.frame.width/16), left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        //        stepBtnsStackView.anchor(top: onboardingView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 25, bottom: 0, right: view.frame.width/2 - 20), size: CGSize(width: 0, height: 0))
    }
    
    func setupLabel() {
        
        if preparationStepsArray?.isEmpty == true {
            stepCounterLbl.text = "Unavailable"
//            print("Unavailable")
        } else {
            stepCounterLbl.text = "Step \(counterSteps) / " + totalStepsLbl.text!
            let range = (stepCounterLbl.text! as NSString).range(of: "/ \(totalSteps)")
            let attributedString = NSMutableAttributedString(string: stepCounterLbl.text!)
            if counterSteps <= totalSteps {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: range)
            }
            stepCounterLbl.attributedText = attributedString
        }
        
        
    }
    
    // MARK: - Selectors
    @objc func closeBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - OnBoaarding (OnScreenStepsVC Extension)
extension OnScreenStepsVC: SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return preparationStepsArray!.count
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let page = SwiftyOnboardPage()
        
        page.title.font = UIFont(name: "AvenirNext-Bold", size: 50)
        page.subTitle.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        let images = UIImage(named: imageArray[index])
        page.imageView.image = images //?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        let sentence = preparationStepsArray![index]
        page.title.text = sentence.components(separatedBy: " ").first
        page.subTitle.text = preparationStepsArray![index]
        
//        page.backgroundColor = .brown
        return page
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
//        overlay.skipButton.isHidden = true
        //        overlay.backgroundColor = .gray
//        overlay.continueButton.isHidden = true
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        //        print(position)
        counterSteps = Int(position) + 1
        //        stepCounterLbl.text = "Step \(counterSteps) / \(totalSteps)"
        setupLabel()
    }
    
}

extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}


extension Collection {
    func shuffled2() -> [Iterator.Element] {
        let shuffledArray = (self as? NSArray)?.shuffled()
        let outputArray = shuffledArray as? [Iterator.Element]
        return outputArray ?? []
    }
    mutating func shuffle() {
        if let selfShuffled = self.shuffled() as? Self {
            self = selfShuffled
        }
    }
}
