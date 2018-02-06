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
    private let moviesManager = MovieManager()
    private var moviesContent = [Movie]()
    private var responseFetchedUp = false
    private var currentPage = 1
    private lazy var searchTextField: UITextField = {
        let frame = getFrameOfSearchTextField()
        let searchField = UITextField(frame: frame)
        setTextField(textField: searchField)
        return searchField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchTextField
        getMovies()
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        currentPage = 1
        moviesManager.searchMovies(page: 1, query: textField.text!) {[weak self] (movies) in
            self?.changeCurrentPageAndUpdateContent(movies: movies)
        }
        return true
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        let movie = moviesContent[indexPath.row]
        cell.configureCell(withMovie: movie)
        return cell
    }
    
    // MARK: - Scroll View
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && responseFetchedUp {
            getMovies()
            responseFetchedUp = false
        }
    }
    
    // MARK: - Methods
    
    private func getMovies() {
        
        moviesManager.getUpcomingMovies(page: currentPage, complition: { [weak self] movies in
            self?.changeCurrentPageAndUpdateContent(movies: movies)
        })
    }
    
    private func reloadTableView() {
        tableView.reloadData()
    }

    private func changeCurrentPageAndUpdateContent(movies: PackageOfMovies) {
        if let result = movies.results {
            self.moviesContent+=result
            self.reloadTableView()
            self.currentPage += 1
            self.responseFetchedUp = true
        }
    }
    
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
