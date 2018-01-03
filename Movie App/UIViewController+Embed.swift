//
//  UIViewController+Embed.swift
//  Movie App
//
//  Created by Bogdan on 30.12.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit

extension UIViewController {
    func embed(viewController: UIViewController, in view: UIView) {
        addChildViewController(viewController)
        view.embed(child: viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    func remove(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}

