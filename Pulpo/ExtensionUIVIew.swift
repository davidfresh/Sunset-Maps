//
//  ExtensionUIVIew.swift
//  Pulpo
//
//  Created by David Vazquez on 4/20/17.
//  Copyright © 2017 davidfresh. All rights reserved.
//

import UIKit

extension UIView{
    
    func fadeOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
    
    func fadeIn(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
        
}

}

extension UIColor {
    class func Pulpo200() -> UIColor {
        return UIColor(red:46.0/255.0, green:125.0/255.0 ,blue:255.0/255.0 , alpha:0.25)
    }
    class func Pulpo100() -> UIColor {
        return UIColor(red:35.0/255.0, green:105.0/255.0 ,blue:214.0/255.0 , alpha:0.25)
    }
    class func Pulpo50() -> UIColor {
        return UIColor(red:75.0/255.0, green:76.0/255.0 ,blue:77.0/255.0 , alpha:0.25)
    }
    class func Pulpo10() -> UIColor {
        return UIColor(red:40.0/255.0, green:42.0/255.0 ,blue:43.0/255.0 , alpha:0.25)
    }
    
    class func PulpoAzul() -> UIColor {
        return UIColor(red:15.0/255.0, green:52.0/255.0 ,blue:83.0/255.0 , alpha:0.25)
    }
    class func PulpoAzul2() -> UIColor {
        return UIColor(red:15.0/255.0, green:52.0/255.0 ,blue:83.0/255.0 , alpha:1.0)
    }
  
}

extension UIViewController{
  func createActivityIndicatory(uiView: UIView) -> UIActivityIndicatorView {
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator.frame =  uiView.frame
    activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    activityIndicator.center = uiView.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = UIColor.black
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    
    for subUIView in uiView.subviews as [UIView] {
      if subUIView.isKind(of:UIActivityIndicatorView.self) {
        subUIView.removeFromSuperview()
      }
    }
    
    uiView.addSubview(activityIndicator)
    uiView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[subview]-0-|",
      options: .directionLeadingToTrailing,
      metrics: nil,
      views: ["subview":activityIndicator]))
    
    uiView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[subview]-0-|",
      options: .directionLeadingToTrailing,
      metrics: nil,
      views: ["subview":activityIndicator]))
    
    
    return activityIndicator
}
}


