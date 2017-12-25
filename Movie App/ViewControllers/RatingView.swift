//
//  RatingView.swift
//  Movie App
//
//  Created by Богдан Семенюк on 11.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    private let radiiDifference: CGFloat = 5.0
    private let pi = Double.pi
    private let arcLayer = CAShapeLayer()
    private let circleLayer = CALayer()
    private let textLayer = CATextLayer()
    private var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        circleLayerSetUp()
        arcLayerSetUp()
        addRatingLabel()
    }
    
    private func circleLayerSetUp() {
        circleLayer.frame = self.bounds
        circleLayer.backgroundColor = UIColor.black.cgColor
        circleLayer.borderWidth = radiiDifference
        circleLayer.borderColor = UIColor(red: 39/255.0, green: 176/255.0, blue: 116/255.0, alpha: 1.0).cgColor
        circleLayer.cornerRadius = halfWidth
        layer.addSublayer(circleLayer)
    }
    
    private func arcLayerSetUp() {
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = halfWidth - radiiDifference / 2
        let startAngle = CGFloat(pi * -1 / 2)
        let endAngle = CGFloat(3 * pi / 2)
        
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        arcLayer.path = circlePath.cgPath
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.strokeColor = UIColor(red: 146/255.0, green: 239/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        arcLayer.lineWidth = radiiDifference;
        arcLayer.strokeEnd = 0.0
        layer.addSublayer(arcLayer)
    }
    
    private func animateCircleLayer(progress: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        arcLayer.strokeEnd = progress
        arcLayer.add(animation, forKey: "animateCircle")
    }
    
    func showRatingWithAnimation(rating: Float) {
        let progress = CGFloat(rating / 10)
        animateCircleLayer(progress: progress)
        
        let attributs = [NSAttributedStringKey.font : UIFont(name: "AmericanTypewriter-CondensedBold", size: 20.0)]
        let attributedStr = NSMutableAttributedString(string: String(rating), attributes: attributs)
        ratingLabel.attributedText = attributedStr
    }
    
    private func addRatingLabel() {
        ratingLabel = UILabel(frame: self.bounds)
        self.addSubview(ratingLabel)
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: ratingLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: ratingLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: ratingLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        self.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
        ratingLabel.textAlignment = .center
        ratingLabel.textColor = UIColor.white
    }
}
