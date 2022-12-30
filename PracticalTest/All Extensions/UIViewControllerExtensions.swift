//
//  UIViewControllerExtensions.swift
//  PracticalTest
//
//  Created by Parth Patel on 27/10/22.
//

import UIKit

extension UIViewController {
    func showLoadingIndicator() {
        let transparentViewFrame = CGRect(x: self.view.bounds.origin.x,
                                          y: self.view.bounds.origin.y,
                                          width: self.view.bounds.size.width,
                                          height: self.view.bounds.size.height)
        let transparentView = UIView(frame: transparentViewFrame)
        transparentView.tag = -2410 //added custom tag
        transparentView.backgroundColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 0.7)
        transparentView.clipsToBounds = true
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = transparentView.center
        activityIndicator.startAnimating()
        activityIndicator.tag = 999999
        transparentView.addSubview(activityIndicator)
        
        self.view.addSubview(transparentView)
    }
    
    func hideLoadingIndicator() {
        for tempSubView in self.view.subviews {
            if tempSubView.tag == -2410 {
                tempSubView.removeFromSuperview()
                break
            } else {
                print("Other views")
            }
        }
    }
    
    func showAlertView(_ title: String, message: String, buttonName: String) {
        let objAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        objAlertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(objAlertController, animated: true)
    }
}
