//
//  Extensions.swift
//  GuideTech
//
//  Created by Valter A. Machado on 3/8/20.
//  Copyright © 2020 Valter A. Machado. All rights reserved.
//

import UIKit

//extension UINavigationController {
//    open override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .darkContent
//    }
//}

extension UIViewController {
    public var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }

    public var isTopViewController: Bool {
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
}


class UrlImageLoader {

var cache = NSCache<AnyObject, AnyObject>()

class var sharedInstance : UrlImageLoader {
    struct Static {
        static let instance : UrlImageLoader = UrlImageLoader()
    }
    return Static.instance
}

func imageForUrl(urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        let data: NSData? = self.cache.object(forKey: urlString as AnyObject) as? NSData

        if let imageData = data {
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async {
                completionHandler(image, urlString)
            }
            return
        }

    let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: URL.init(string: urlString)!) { (data, response, error) in
        if error == nil {
            if data != nil {
                let image = UIImage.init(data: data!)
                self.cache.setObject(data! as AnyObject, forKey: urlString as AnyObject)
                DispatchQueue.main.async {
                    completionHandler(image, urlString)
                }
            }
        } else {
            completionHandler(nil, urlString)
        }
    }
    downloadTask.resume()
    }
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}


// MARK: - Brute Force Algorithm
extension String {
 func index(of pattern: String) -> Index? {
    // 1
    for i in indices {

      // 2
      var j = i
      var found = true
      for p in pattern.indices {
        guard j != endIndex && self[j] == pattern[p] else { found = false; break }
        j = index(after: j)
      }
      if found {
        return i
      }
    }
    return nil
  }
  }

// MARK: - find the difference between two arrays
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}


extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

public extension UIViewController {
    func setStatusBar(color: UIColor) {
        let tag = 12321
        if let taggedView = self.view.viewWithTag(tag){
            taggedView.removeFromSuperview()
        }
        let overView = UIView()
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame
        overView.frame = statusBarFrame!
        overView.backgroundColor = color
        overView.tag = tag
        self.view.addSubview(overView)
    }
}

extension UIView {
  func fadeTo(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
    DispatchQueue.main.async {
      UIView.animate(withDuration: duration) {
        self.alpha = alpha
      }
    }
  }

  func fadeIn(_ duration: TimeInterval = 0.3) {
    fadeTo(1.0, duration: duration)
  }

  func fadeOut(_ duration: TimeInterval = 0.3) {
    fadeTo(0.0, duration: duration)
  }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
     func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
             }, completion: completion)  }
 
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}

class Utilities {
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}


extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.yourApp.notifications.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.yourApp.notifications.darkModeDisabled")
}

// MARK: Localization Lang Extension

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}


extension String {
func localized(_ lang:String) ->String {

    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)

    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}
    
}

public extension UICollectionView {

  /**
  This method returns the indexPath of the cell that contains the specified view (e.g. Button, TextView)

   - Parameter view: The view to find.

   - Returns: The indexPath of the cell containing the view, or nil if it can't be found

  */

    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = self.convert(center, from: view.superview)
        let indexPath = self.indexPathForItem(at: viewCenter)
        return indexPath
    }
}


extension String {
   func maxLength(length: Int) -> String {
       var str = self
       let nsString = str as NSString
       if nsString.length >= length {
           str = nsString.substring(with:
               NSRange(
                location: 0,
                length: nsString.length > length ? length : nsString.length)
           )
       }
       return  str
   }
}

extension UIButton {
    

  func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {

    guard let imageView = self.currentImage,
    let titleLabel = self.titleLabel?.text else { return }

    let sign: CGFloat = imageOnTop ? 1 : -1
    self.titleEdgeInsets = UIEdgeInsets(top: (imageView.size.height + gap) * sign, left: -imageView.size.width, bottom: 0, right: 0);

    let titleSize = titleLabel.size(withAttributes:[NSAttributedString.Key.font: self.titleLabel!.font!])
    self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
  }
    
    func alignTextBelow(spacing: CGFloat = 6.0) { // default spacing is 6.0
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font!
        ])
        
      
            titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}

extension UIView {
    
    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}


extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        //    self.layer.borderWidth = 4.0
        //    self.layer.borderColor = UIColor.rgb(red: 235, green: 51, blue: 72) as! CGColor
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

func setTitle(title:String, subtitle:String) -> UIView {
    let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
    
    titleLabel.backgroundColor = UIColor.clear
    titleLabel.textColor = UIColor.gray
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.text = title
    titleLabel.sizeToFit()
    
    let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
    subtitleLabel.backgroundColor = UIColor.clear
    subtitleLabel.textColor = UIColor.black
    subtitleLabel.font = UIFont.systemFont(ofSize: 12)
    subtitleLabel.text = subtitle
    subtitleLabel.sizeToFit()
    
    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
    titleView.addSubview(titleLabel)
    titleView.addSubview(subtitleLabel)
    
    let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
    
    if widthDiff < 0 {
        let newX = widthDiff / 2
        subtitleLabel.frame.origin.x = abs(newX)
    } else {
        let newX = widthDiff / 2
        titleLabel.frame.origin.x = newX
    }
    
    return titleView
}

extension UINavigationBar {
    
    func hideNavBarSeperator()
    {
        let img = UIImage()
        self.shadowImage = img
        self.setBackgroundImage(img, for: UIBarMetrics.default)
    }
    
    func showNavBarSeperator()
    {
        let img = UIImage.pixelImageWithColor(color: UIColor.lightGray)//Use Any Color
        self.shadowImage = img
    }
}
extension UIImage {
    class func pixelImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
extension UIView {
    func addDashedBorder() {
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 3
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        //    self.layer.masksToBounds = true
        self.layer.addSublayer(shapeLayer)
    }
    
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.clipsToBounds = true
//        subView.layer.cornerRadius = 10
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }

    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
}

extension UIAlertController {
    func fixActionSheetConstraintsError() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

extension UIContextMenuInteraction {
    func fixActionSheetConstraintsError() {
        guard let view = self.view else { return }
        for subView in view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
