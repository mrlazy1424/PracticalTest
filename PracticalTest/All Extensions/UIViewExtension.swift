//
//  UIViewExtension.swift
//  PracticalTest
//
//  Created by Parth Patel on 27/10/22.
//

import UIKit

extension UIView {
    func addShadowToView(_ shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}
