//
//  ViewController.swift
//  MovieTranslator
//
//  Created by Никита on 09.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate {
    //UI
    @IBOutlet weak var moviesTableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
    var searchController: UISearchController?
    //Data
    var movie : MovieModel?
    var dataSource = [MovieModel]()
    //movie genre
    var genreList : GenreList?
    var genre: GenreModel?
    static var genres = [GenreModel]()
    var genreDictionaryArray = [Dictionary<String, Any>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarTitleIfNeed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: String(describing: MovieTableViewCell.self) , for: indexPath) as! MovieTableViewCell
        movie = dataSource[indexPath.row]
        cell.load(withMovie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = dataSource[indexPath.row]
        showMovieDetailViewController(forMovie: movie)
    }
    
    func showMovieDetailViewController(forMovie movie: MovieModel) {
        let detailMovieViewController = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        detailMovieViewController.movie = movie
        self.navigationController?.pushViewController(detailMovieViewController, animated: true)
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
        getPopularMovies()
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
            searchController?.searchBar.tintColor = .lightGray
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = searchController
        }
        
    }
    
    private func setNavigationBarTitleIfNeed() {
        if self.navigationItem.title == nil || self.navigationItem.title?.count == 0 {
            self.navigationItem.title = "Popular movies"
        }
    }
    
    private func customizeSearchBar() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search movies", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        for view in (self.searchController?.searchBar.subviews)! {
            for subView:UIView in (view.subviews)
            {
                if ( subView is UITextField) {
                    let textField = subView as! UITextField
                    textField.textColor = .white
                }
            }
        }
    }
    
    //MARK: - API Requests
    
    private func getPopularMovies() {
        MovieService.shared.getMovies(page: 55) { [weak self] (movies, error) in
            let weakSelf = self
            weakSelf?.dataSource.removeAll()
            weakSelf?.dataSource = movies as! [MovieModel]
            weakSelf?.moviesTableView.reloadData()
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
    
    
    //MARK: - UISearchControllerDelegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        customizeSearchBar()
    }


}

