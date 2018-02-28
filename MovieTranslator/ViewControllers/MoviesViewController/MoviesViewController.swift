//
//  ViewController.swift
//  MovieTranslator
//
//  Created by Никита on 09.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate {
    //UI
    @IBOutlet weak var moviesTableView: UITableView!
    var noResultsLabel = UILabel()
    var searchController: UISearchController?
    //Navigation
    lazy var router : Router = {
        Router(self.navigationController)
    }()
    //Data
    var movie : MovieModel?
    var moviesPage : Int = defaultMoviePage
    var isSearchingNow = false
    var searchTerms = ""
    var searchArrayCount = 0
    let topIndexPath = IndexPath(row: 0, section: 0)
    var dataSource = [MovieModel]()
    var searchResults = [MovieModel]()
    fileprivate var timer: Timer?
    
    //movie genre
    var genreList : GenreList?
    var genre: GenreModel?
    static var genres = [GenreModel]()
    var genreDictionaryArray = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setNavigationBarTitleIfNeed()
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self) , for: indexPath) as! MovieTableViewCell
        //check for the last element of page
        var movieIndex = indexPath.row + 1
        if movieIndex == tableView.numberOfRows(inSection: 0) {
            //check for the request type (search or get)
            if !isSearchingNow {
                getPopularMovies(page: moviesPage)
            } else {
                //check for the search result available
                if searchArrayCount > 0 && searchArrayCount < 21 {
                    searchMovies(text: searchTerms, page: moviesPage)
                }
            }
        }
        movie = dataSource[indexPath.row]
        cell.load(withMovie: movie)
        hideLoading()
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = dataSource[indexPath.row]
        router.showMovieDetailViewController(forMovie: movie)
    }
    
    //MARK: - Private
    
    private func initGenres() {
        for genreDictionary in genreDictionaryArray {
            let id = genreDictionary["id"] as! Int
            let name = genreDictionary["name"] as! String
            genre = GenreModel(withID: id, name)
            MoviesViewController.genres.append(genre!)
        }

    }
    
    private func prepareContent() {
        getPopularMovies(page: moviesPage)
        getGenresInformation()
    }
    
    private func registerCell() {
        moviesTableView.register(UINib(nibName:String(describing: MovieTableViewCell.self), bundle: nil) , forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
    }
    
    private func tableViewSettings() {
        registerCell()
        prepareContent()
        moviesTableView.estimatedRowHeight = 300
        moviesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func initialSetup() {
        tableViewSettings()
        setSearchBarToNavigationBar()
    }
    
    //MARK: - Navigation bar settings
    
    private func setSearchBarToNavigationBar() {
        if #available(iOS 11.0, *) {
            searchController = UISearchController(searchResultsController: nil)
            searchController?.delegate = self
            searchController?.searchBar.delegate = self
            searchController?.searchBar.tintColor = .lightGray
            searchController?.searchBar.returnKeyType = .done
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = searchController
        }
        
    }
    
    private func customizeSearchBar() {
        for view in (self.searchController?.searchBar.subviews)! {
            for subView:UIView in (view.subviews)
            {
                if ( subView is UITextField) {
                    let textField = subView as! UITextField
                    textField.clearButtonMode = .never
                    textField.textColor = .white
                }
                
                if (view is UIButton) {
                    var button = view as! UIButton
                    button.titleLabel?.text = ""
                }
                
            }
        }
        searchController?.searchBar.setValue("", forKey:"_cancelButtonText")
    }
    
    private func setNavigationBarTitleIfNeed() {
        if self.navigationItem.title == nil {
            self.navigationItem.title = popularMoviesNavigationBarTitle
        }
    }
    
    private func setNoResultsLabel() {
        noResultsLabel.isHidden = false
        noResultsLabel.textColor = .white
        noResultsLabel.font = UIFont.boldSystemFont(ofSize: 30)
        noResultsLabel.text = "The search has not given any results"
        noResultsLabel.center = view.center
    }
    
    //MARK: - API Requests
    
    private func getPopularMovies(page : Int) {
        showLoading()
//        noResultsLabel.isHidden = true
            MovieService.shared.getMovies(page: page) { [weak self] (movies, error) in
                let weakSelf = self
                weakSelf?.isSearchingNow = false
                weakSelf?.dataSource += movies as! [MovieModel]
                weakSelf?.moviesPage += 1
                weakSelf?.moviesTableView.reloadData()
                weakSelf?.hideLoading()
                weakSelf?.navigationItem.title = popularMoviesNavigationBarTitle
                UserDefaults.standard.setValue(false, forKey:"isSearchingOnce")
            }
    }
    
    private func getGenresInformation() {
        MovieService.shared.getGenreList { [weak self] (genreList, error) in
            let weakSelf = self
            weakSelf?.genreList = genreList as? GenreList
            if weakSelf?.genreList?.list != nil {
                weakSelf?.genreDictionaryArray = (weakSelf?.genreList?.list!)!
                weakSelf?.initGenres()
                weakSelf?.hideLoading()
            }
        }
    }
    
    func searchMovies(text: String, page: Int) {
        showLoading()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            
            MovieService.shared.searchMovies(query: text, page: page, completion: { [weak self] (response, error) in
                
                let weakSelf = self
                if (error != nil) {
                    if (error is Error ) {
                        weakSelf?.showAlert(withMessage: (error?.description)!)
                    }
                    return
                }
                
                weakSelf?.hideLoading()
                weakSelf?.isSearchingNow = true
                let searchArray = response as! [MovieModel]
                weakSelf?.searchArrayCount = searchArray.count
                weakSelf?.searchResults += searchArray
                weakSelf?.dataSource = (weakSelf?.searchResults)!
                weakSelf?.moviesTableView.reloadData()
                weakSelf?.navigationItem.title = searchResultsNavigationBarTitle
                weakSelf?.moviesPage += 1
                
                let isSearchingOnce = UserDefaults.standard.value(forKey: "isSearchingOnce") as! Bool
                if !isSearchingOnce {
                    if (weakSelf?.dataSource.count)! > 0 {
                        weakSelf?.moviesTableView.scrollToRow(at: (weakSelf?.topIndexPath)!, at: .top, animated: true)
                    }
                UserDefaults.standard.setValue(true, forKey:"isSearchingOnce")
                    
                }
            })
        }
    }
    
    @objc func callSearch() {
        guard let text = searchController?.searchBar.text else {return}
        if text.isEmpty {
            dataSource.removeAll()
            moviesTableView.reloadData()
            return
        }
        searchMovies(text: text, page: moviesPage)
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        moviesPage = defaultMoviePage
        searchTerms = searchText
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callSearch), userInfo: nil, repeats: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty)! || searchBar.text == "" {
            moviesPage = defaultMoviePage
            getPopularMovies(page: moviesPage)
        }
        searchController?.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSettings(searchBar: UISearchBar) {
        if (searchController?.isActive)! {
            searchTerms = searchBar.text!
        }
        if (searchBar.text?.isEmpty)! || searchBar.text == "" {
            moviesPage = defaultMoviePage
            getPopularMovies(page: moviesPage)
        }
    }
    
    //MARK: - UISearchControllerDelegate
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        customizeSearchBar()
        searchController.searchBar.text = searchTerms
    }
    
}

