//
//  SearchViewController.swift
//  Movie App
//
//  Created by Bogdan on 01.02.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    lazy var searchTextField: UITextField = {
        let frame = getFrameOfSearchTextField()
        let textField = UITextField(frame: frame)
        textField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchTextField
        
    }
    
    func getFrameOfSearchTextField() -> CGRect {
        if let navBarBounds = navigationController?.navigationBar.bounds.size {
            let point = CGPoint(x: 0.0, y: 0.0)
            let height = navBarBounds.height - 12.0
            let wight = navBarBounds.width - 150.0
            return CGRect(origin: point, size: CGSize(width: wight, height: height))
        }
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    static func create() -> UIViewController {
        let vc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchVC")
        return vc
    }
}
