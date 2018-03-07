//
//  ViewController.swift
//  MovieTranslator
//
//  Created by Никита on 09.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import UIKit

class MoviesViewController: BaseViewController, UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultsView: UIView!
    
    var movie : MovieModel?
    var moviesPage : Int = defaultMoviePage
    var isSearchingNow = false
    var isLoadingNow = false
    var searchTerms = ""
    var offset = CGPoint()
    var dataSource = [MovieModel]()
    var searchResults = [MovieModel]()
    var tempResults = [MovieModel]()
    fileprivate var timer: Timer?
    
    var genreList : GenreList?
    var genre: GenreModel?
    static var genres = [GenreModel]()
    var genresArray : [GenreModel]?
    var genreDictionaryArray = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (navigationController?.isNavigationBarHidden)! {
            showHideSearchBar()
            hideKeyboard()
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func showSearchBar(_ sender: Any) {
        showHideSearchBar()
    }
    
    @IBAction func backToPopularMovies(_ sender: Any) {
        searchBar.text = ""
        
        moviesTableView.reloadData()
        scrollTableViewToTop()
        getPopularMovies(page: defaultMoviePage)
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchingNow ? searchResults.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self) , for: indexPath) as! MovieTableViewCell
        
        movie = isSearchingNow ? searchResults[indexPath.row] : dataSource[indexPath.row]
        cell.load(withMovie: movie)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = isSearchingNow ? searchResults[indexPath.row] : dataSource[indexPath.row]
        router.showMovieDetailViewController(forMovie: movie)
    }
    
    //MARK: - Private
    
    private func initGenres() {
        for genreDictionary in genreDictionaryArray {
            guard let id = genreDictionary["id"] as? Int else {return}
            guard let name = genreDictionary["name"] as? String else {return}
            genre = GenreModel(withID: id, name)
            MoviesViewController.genres.append(genre!)
        }
    }
    
    private func setupNoResultsView(whereDataSourceIs source: [MovieModel]?) {
        moviesTableView.isHidden = (source?.isEmpty)!
        noResultsView.isHidden = !(source?.isEmpty)!
    }
    
    private func prepareContent() {
        getGenresInformation()
        getPopularMovies(page: moviesPage)
    }
    
    private func registerCell() {
        moviesTableView.register(UINib(nibName:String(describing: MovieTableViewCell.self), bundle: nil) , forCellReuseIdentifier: String(describing: MovieTableViewCell.self))
    }
    
    private func tableViewSettings() {
        registerCell()
        moviesTableView.estimatedRowHeight =  tableViewRowHeight
        moviesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func initialSetup() {
        tableViewSettings()
        prepareContent()
    }
    
    
 
    //MARK: - API Requests
    
    private func getPopularMovies(page : Int) {
        showLoading()
        if Reachability.isConnectedToNetwork() {
            MovieService.shared.getMovies(page: page) { [weak self] (movies, error) in
                let weakSelf = self
                weakSelf?.isSearchingNow = false
                weakSelf?.searchBar.isHidden = true
                weakSelf?.dataSource += movies as! [MovieModel]
                weakSelf?.tempResults = movies as! [MovieModel]
                weakSelf?.moviesPage += 1
                weakSelf?.hideLoading()
                weakSelf?.moviesTableView.reloadData()
                weakSelf?.setupNoResultsView(whereDataSourceIs: weakSelf?.dataSource)
                weakSelf?.hideBackButton()
                weakSelf?.setNavigationBarTitleIfNeed()
                weakSelf?.isLoadingNow = false
            }
        } else {
            hideLoading()
            let alertAction = UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                self.getPopularMovies(page: page)
            })
            showNetworkingAlert(withAction: alertAction)
        }
    }
    
    private func getGenresInformation() {
        MovieService.shared.getGenreList { [weak self] (genreList, error) in
            let weakSelf = self
            weakSelf?.genreList = genreList as? GenreList
            if weakSelf?.genreList?.list != nil {
                weakSelf?.genreDictionaryArray = (weakSelf?.genreList?.list!)!
                weakSelf?.initGenres()
            }
        }
    }
    
    func searchMovies(text: String, page: Int) {
        showLoading()
        if Reachability.isConnectedToNetwork() {
            MovieService.shared.searchMovies(query: text, page: page, completion: { [weak self] (response, error) in
                
                let weakSelf = self
                
                if (error != nil) {
                    if (error is Error ) {
                        weakSelf?.showAlert(withMessage: (error?.description)!, actionOK: nil)
                    }
                    return
                }
                
                weakSelf?.hideLoading()
                weakSelf?.isSearchingNow = true
                let searchArray = response as! [MovieModel]
                weakSelf?.tempResults = searchArray
                weakSelf?.searchResults += searchArray
                weakSelf?.moviesTableView.reloadData()
                weakSelf?.setNavigationBarTitleIfNeed()
                weakSelf?.moviesPage += 1
                weakSelf?.isLoadingNow = false
                weakSelf?.setupNoResultsView(whereDataSourceIs: weakSelf?.searchResults)
                if (weakSelf?.searchResults.isEmpty)! {
                    weakSelf?.hideKeyboard()
                }
                weakSelf?.showBackButton()
                //scroll to Top position if it's simple search request (first request)
                let isFirstSearch = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstSearch.rawValue)
                if !isFirstSearch {
                    if (weakSelf?.searchResults.count)! > 0 {
                        weakSelf?.scrollTableViewToTop()
                    }
                }
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isFirstSearch.rawValue)
                //
            })
        } else {
            hideLoading()
            let alertAction = UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                self.showHideSearchBar()
            })
            showNetworkingAlert(withAction: alertAction)
        }
        
    }
    
    @objc func callSearch() {
        guard let text = searchBar.text else {return}
        if !text.isEmpty && !text.isWhiteSpace() {
            searchMovies(text: text, page: moviesPage)
        } else {
            scrollTableViewToTop()
            showHideSearchBar()
            getPopularMovies(page: defaultMoviePage)
        }
    }
    
    //MARK: - Customize UI
    
    private func scrollTableViewToTop() {
        let source = isSearchingNow ? searchResults : dataSource
        if !source.isEmpty {
            moviesTableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
        }
    }
    
    private func setNavigationBarTitleIfNeed() {
        title = isSearchingNow ? searchResultsNavigationBarTitle :  popularMoviesNavigationBarTitle
    }
    
    
    private func showHideSearchBar() {
        searchBar.isHidden = !searchBar.isHidden

        if searchBar.isHidden {
            navigationController?.setNavigationBarHidden(false, animated: true)
            hideKeyboard()
            showSearchButton()
        } else {
            searchBar.becomeFirstResponder()
            navigationController?.setNavigationBarHidden(true, animated: true)
            hideSearchButton()
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func hideBackButton() {
        backButton.isEnabled = false
        backButton.tintColor = .clear
    }
    
    func showBackButton() {
        backButton.isEnabled = true
        backButton.tintColor = .white
    }
    
    func hideSearchButton() {
        searchButton.isEnabled = false
        searchButton.tintColor = .clear
    }
    
    func showSearchButton() {
        searchButton.isEnabled = true
        searchButton.tintColor = .white
    }
    
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isFirstSearch.rawValue)
        moviesPage = defaultMoviePage
        searchTerms = searchText
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: searchTimerInterval, target: self, selector: #selector(callSearch), userInfo: nil, repeats: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        for char in disallowedCharacters {
            if text == String(char) || text.firstCharIsWhiteSpace() {
                return false
            }
        }
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        searchTerms = text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showHideSearchBar()
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offset = moviesTableView.contentOffset
        let heightDifference = moviesTableView.contentSize.height - moviesTableView.frame.size.height
        
        if offset.y > (heightDifference) {
            if !isLoadingNow {
                if tempResults.count >= onePageMoviesCount {
                    isSearchingNow ? searchMovies(text: searchTerms, page: moviesPage) : getPopularMovies(page: moviesPage)
                    isLoadingNow = true
                }
            }
        }
    }
    
    
}

