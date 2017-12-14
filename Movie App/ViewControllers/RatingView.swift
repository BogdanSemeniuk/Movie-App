//
//  RatingView.swift
//  Movie App
//
//  Created by Богдан Семенюк on 11.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

protocol RatingViewDelegate {
    var rating: Double {get}
}

class RatingView: UIView {
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    private let radiiDifference: CGFloat = 5.0
    var delegate: RatingViewDelegate?
    private let pi = Double.pi

    override func awakeFromNib() {
        setUpLayer()
    }
    
    private func setUpLayer() {
        layer.backgroundColor = UIColor.black.cgColor
        layer.borderWidth = radiiDifference
        layer.borderColor = UIColor(red: 127/255.0, green: 127/255.0, blue: 127/255.0, alpha: 1.0).cgColor
        layer.cornerRadius = halfWidth
    }
    
    private func arcCreating() {
        let circleLayer = CAShapeLayer()
        
        let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let radius = halfWidth - radiiDifference / 2
        let startAngle = CGFloat(3 * pi / 2)
        let endAngle = CGFloat((delegate?.rating)! * 0.2 * pi - 0.5 * pi)
        
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
    }
}
