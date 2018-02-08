//
//  SearchViewController.swift
//  Movie App
//
//  Created by Bogdan on 01.02.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    private let moviesManager = MovieManager()
    private var moviesContent = [Movie]() {
        didSet {
            tableView.reloadData()
            contentWasSet = true
        }
    }
    private var contentWasSet = false
    private var workItem: DispatchWorkItem?
    private var searchQuery = SearchQuery(query: "", page: 1, totalPages: 0)
    private lazy var searchTextField: UITextField = {
        let frame = getFrameOfSearchTextField()
        let searchField = UITextField(frame: frame)
        setTextField(textField: searchField)
        return searchField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchTextField
        
        moviesManager.getUpcomingMovies(page: 1, complition: { [weak self] packageOfMovies in
            if let movies = packageOfMovies.results {
                self?.moviesContent = movies
            }
        })
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchQuery = SearchQuery(query: "", page: 1, totalPages: 0)
        workItem?.cancel()
        let queryString = createQueryString(replacementString: string)
        workItem = DispatchWorkItem  {
            self.searchMovies(withQuery: queryString)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem!)
        return true
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        let movie = moviesContent[indexPath.row]
        cell.configureCell(withMovie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Movies", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetails") as! MovieDetailsViewController
        vc.movieDetails = moviesContent[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && contentWasSet {
            contentWasSet = false
            searchMovies(withQuery: searchQuery.query)
        }
    }
    
    // MARK: - Methods
    
    private func searchMovies(withQuery query: String) {
        let page = searchQuery.page
        self.moviesManager.searchMovies(page: page, query: query) { [weak self] (packageOfMovies) in
            guard let totalPages = packageOfMovies.totalPages else { return }
            guard let movies = packageOfMovies.results else { return }
            self?.searchQuery.totalPages = totalPages
            if page == 1 {
               self?.moviesContent = movies
            } else {
                self?.moviesContent += movies
            }
            self?.updateSearchQuery(query: query)
        }
    }
    
    private func updateSearchQuery(query: String) {
        searchQuery.query = query
        if searchQuery.page < searchQuery.totalPages {
            searchQuery.page += 1
        }
    }
    
    private func createQueryString(replacementString string: String) -> String {
        guard let textFieldString = searchTextField.text else { return "" }
        var queryString = textFieldString
        if string == "" {
            queryString.removeLast()
        } else {
            queryString = queryString + string
        }
        return queryString
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
