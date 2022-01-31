//
//  spinner.swift
//  PetWorld
//
//  Created by joseph on 2020/6/16.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//
import Foundation
import UIKit

class spinner: UIView {

let imageView = UIImageView()

init(frame: CGRect, image: UIImage) {
    super.init(frame: frame)
    
    imageView.frame = bounds
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(imageView)
    
}

required init(coder: NSCoder) {
    fatalError()
}

func startAnimating() {
    isHidden = false
    rotate()
}

func stopAnimating() {
    isHidden = true
    removeRotation()
}

private func rotate() {
    let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotation.toValue = NSNumber(value: Double.pi * 2)
    rotation.duration = 1
    rotation.isCumulative = true
    rotation.repeatCount = Float.greatestFiniteMagnitude
    self.imageView.layer.add(rotation, forKey: "rotationAnimation")
}

private func removeRotation() {
    self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
}
}
