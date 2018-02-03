//
//  SearchViewController.swift
//  Movie App
//
//  Created by Bogdan on 01.02.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchTextField: UITextField = {
        let frame = getFrameOfSearchTextField()
        let searchField = UITextField(frame: frame)
        setTextField(textField: searchField)
        return searchField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchTextField
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlistAndSearchCell", for: indexPath) as! WatchlistAndSearchCell
        return cell
    }
    
    // MARK: - Methods
    
    private func getFrameOfSearchTextField() -> CGRect {
        if let navBarBounds = navigationController?.navigationBar.bounds.size {
            let point = CGPoint(x: 0.0, y: 0.0)
            let height = navBarBounds.height - 12.0
            let wight = navBarBounds.width - 150.0
            return CGRect(origin: point, size: CGSize(width: wight, height: height))
        }
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    private func setTextField(textField: UITextField) {
        textField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search🔎"
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
    }
    
    static func create() -> UIViewController {
        let vc = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchVC")
        return vc
    }
}
