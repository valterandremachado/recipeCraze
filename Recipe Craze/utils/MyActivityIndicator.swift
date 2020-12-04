//
//  MyActivityIndicator.swift
//  GuideTech
//
//  Created by Valter A. Machado on 3/30/20.
//  Copyright © 2020 Valter A. Machado. All rights reserved.
//

import UIKit
import Foundation

class ProgressIndicator: UIView {

    var indicatorColor:UIColor
    var loadingViewColor:UIColor
    var loadingMessage:String
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()

    init(inview: UIView, loadingViewColor: UIColor, indicatorColor: UIColor, msg: String){

        self.indicatorColor = indicatorColor
        self.loadingViewColor = loadingViewColor
        self.loadingMessage = msg   //   - 25
        super.init(frame: CGRect(x: inview.frame.midX , y: inview.frame.midY , width: 30, height: 45))
        initalizeCustomIndicator()

    }
    convenience init(inview:UIView) {

        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: "Loading..")
    }
    convenience init(inview:UIView,messsage:String) {

        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: messsage)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func initalizeCustomIndicator(){

        messageFrame.frame = self.bounds
        activityIndicator = UIActivityIndicatorView(style: .medium)  // indicator main size
        activityIndicator.tintColor = indicatorColor
        activityIndicator.color = indicatorColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: self.bounds.origin.x + 9, y: 7, width: 20, height: 30) // indicator view size
        print(activityIndicator.frame)
        
        let strLabel = UILabel(frame:CGRect(x: self.bounds.origin.x + 30, y: 0, width: self.bounds.width - (self.bounds.origin.x + 30) , height: 50))
        strLabel.text = loadingMessage
        strLabel.adjustsFontSizeToFitWidth = true
        strLabel.textColor = UIColor.white
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = loadingViewColor
        messageFrame.alpha = 0.8
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)


    }

    func  start(){
        //check if view is already there or not..if again started
        if !self.subviews.contains(messageFrame){

            activityIndicator.startAnimating()
            self.addSubview(messageFrame)

        }
    }

    func stop(){

        if self.subviews.contains(messageFrame){

            activityIndicator.stopAnimating()
            messageFrame.removeFromSuperview()

        }
    }
}



class ProgressIndicatorLarge: UIView {

    var indicatorColor:UIColor
    var loadingViewColor:UIColor
    var loadingMessage:String
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()

    init(inview: UIView, loadingViewColor: UIColor, indicatorColor: UIColor, msg: String){

        self.indicatorColor = indicatorColor
        self.loadingViewColor = loadingViewColor
        self.loadingMessage = msg   //   - 25
        super.init(frame: CGRect(x: inview.frame.midX , y: inview.frame.midY , width: 30, height: 45))
        initalizeCustomIndicator()

    }
    convenience init(inview:UIView) {

        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: "Loading..")
    }
    convenience init(inview:UIView,messsage:String) {

        self.init(inview: inview,loadingViewColor: UIColor.brown,indicatorColor:UIColor.black, msg: messsage)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func initalizeCustomIndicator(){

        messageFrame.frame = self.bounds
        activityIndicator = UIActivityIndicatorView(style: .large) // indicator main size
        activityIndicator.tintColor = indicatorColor
        activityIndicator.color = indicatorColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: self.bounds.origin.x + 6, y: 0, width: 20, height: 50) // indicator view size
//        print(activityIndicator.frame)
        let strLabel = UILabel(frame:CGRect(x: self.bounds.origin.x + 30, y: 0, width: self.bounds.width - (self.bounds.origin.x + 30) , height: 50))
        strLabel.text = loadingMessage
        strLabel.adjustsFontSizeToFitWidth = true
        strLabel.textColor = UIColor.white
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = loadingViewColor
        messageFrame.alpha = 0.8
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)


    }

    func  start(){
        //check if view is already there or not..if again started
        if !self.subviews.contains(messageFrame){

            activityIndicator.startAnimating()
            self.addSubview(messageFrame)

        }
    }

    func stop(){

        if self.subviews.contains(messageFrame){

            activityIndicator.stopAnimating()
            messageFrame.removeFromSuperview()

        }
    }
}
