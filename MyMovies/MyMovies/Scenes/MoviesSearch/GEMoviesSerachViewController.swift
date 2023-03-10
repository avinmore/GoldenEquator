//
//  GEMoviesSerachViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import UIKit
class GEMoviesSerachViewController: GEMoviesBaseViewController {
    lazy var viewModel = GEMoviesSerachViewModel()
    var collectionView: UICollectionView!
    lazy var searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = setupCollectionView(self)
        collectionView.dataSource = nil
        setupDataSource()
        setupSearchBar()
        title = "Search"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MyMoviesUtils.showToast("Type movie name to search!!", duration: 3)
    }
    
    func setupDataSource() {
        viewModel.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CGMovieCollectionViewCell", for: indexPath) as? CGMovieCollectionViewCell else {
                assertionFailure()
                return UICollectionViewCell()
            }
            let movie = self.viewModel.movieData[indexPath.row]
            cell.loadCellData(movie)
            return cell
        })
    }
    
    func setupSearchBar() {
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.tintColor = ThemeManager.searchBarTintColor
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = ThemeManager.searchBarTintColor
        let imageView = textFieldInsideSearchBar?.leftView as? UIImageView
        imageView?.image = imageView?.image?.withRenderingMode(.alwaysTemplate)
        imageView?.tintColor = ThemeManager.searchBarTintColor
        self.searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
}

extension GEMoviesSerachViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var searchString = searchController.searchBar.text
        searchString = searchString?.trimmingCharacters(in: .whitespaces)
        let filteredString = searchString?.replacingOccurrences(of: "[\\s.]{2,}", with: "", options: .regularExpression)
        if filteredString != viewModel.movieName {
            viewModel.movieName = filteredString ?? ""
        }
    }
}
extension GEMoviesSerachViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let totalItemCount = self.viewModel.movieData.count
        if indexPath.row == totalItemCount - 5 {
            viewModel.fetchData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movieData[indexPath.row]
        navigateToMovieDetails(movie.id)
    }
    

}

