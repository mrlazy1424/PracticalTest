//
//  LazyImageView.swift
//  PracticalTest
//
//  Created by Parth Patel on 27/10/22.
//

import UIKit

class LazyImageView: UIImageView {

    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(_ imageURL: URL, placeHolderImage: UIImage, isInvertedImage: Bool) {
        self.image = placeHolderImage
        
        /*if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            return
        }*/
        
        if let objCachedImageData = UserDefaults.standard.value(forKey: imageURL.absoluteString) as? Data {
            if let image = UIImage(data: objCachedImageData) {
                self.image = image
                if isInvertedImage {
                    self.image = image.invertedImage()
                }
                return
            }
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data (contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                        if isInvertedImage {
                            self?.image = image.invertedImage()
                        }
                        UserDefaults.standard.setValue(imageData, forKey: imageURL.absoluteString)
                    }
                }
            }
        }
    }
}
