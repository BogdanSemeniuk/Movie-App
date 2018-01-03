//
//  UIView+Embed.swift
//  Movie App
//
//  Created by Bogdan on 30.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

extension UIView {
    func embed(child view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.frame = bounds
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ])
    }
    
}
