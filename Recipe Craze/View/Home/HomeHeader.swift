//
//  HomeHeader.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/7/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

class HomeHeader: UICollectionViewCell {
    // MARK: - Properties
    lazy var sloganLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Search, cook,\nshare and repeat!"
        lbl.numberOfLines = 0 // 0 = as many lines as the label needs
        lbl.frame.origin.x = 32
        lbl.frame.origin.y = 32
        lbl.frame.size.width = self.bounds.width - 64
        lbl.font = UIFont.boldSystemFont(ofSize: 44) // my UIFont extension
        //        lbl.textColor = UIColor.black
        //        lbl.backgroundColor = .red
        lbl.sizeToFit()
        return lbl
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "backgroundAppearance")
        setupViews()
    }
    
    // MARK: - Methods
    fileprivate func setupViews(){
        [sloganLabel].forEach({contentView.addSubview($0)})
//        sloganLabel.backgroundColor = .red
        sloganLabel.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class TableViewHeader: UITableViewHeaderFooterView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    @objc dynamic var forceBackgroundColor: UIColor? {
        get { return self.contentView.backgroundColor }
        set(color) {
            self.contentView.backgroundColor = color
            // if your color is not opaque, adjust backgroundView as well
            self.backgroundView?.backgroundColor = .clear
        }
    }

}
