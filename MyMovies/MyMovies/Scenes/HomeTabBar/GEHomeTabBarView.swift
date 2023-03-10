//
//  GEHomeTabBarView.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//
import UIKit

class GEHomeTabBarView: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbatAppearance()
        setupNavigationActionItems()
        setupTabbarViewControllers()
    }
    
    private func setupTabbatAppearance() {
        //view.backgroundColor = .white
        UITabBar.appearance().backgroundColor = ThemeManager.barTintColor
        UITabBar.appearance().barTintColor = ThemeManager.barTintColor
    }
    
    private func setupTabbarViewControllers() {
        let nowPlaying = GENowPlayingMoviesViewController()
        let nowPlayingTabBarItem = UITabBarItem(title: "Now Playing", image: UIImage(named: "now-playing"), tag: 0)
        nowPlaying.tabBarItem = nowPlayingTabBarItem
        setTabBarItemTextColor(nowPlayingTabBarItem)
        
        let popular = GEPopularMoviesViewController()
        let secondTabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "popular"), tag: 1)
        popular.tabBarItem = secondTabBarItem
        setTabBarItemTextColor(secondTabBarItem)
        
        let toprated = GETopRatedMoviesViewController()
        let topratedTabBarItem = UITabBarItem(title: "Top Rated", image: UIImage(named: "top-rated"), tag: 2)
        toprated.tabBarItem = topratedTabBarItem
        setTabBarItemTextColor(topratedTabBarItem)
        
        let upcoming = GEUpcomingMoviesViewController()
        let upcomingTabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(named: "upcoming"), tag: 3)
        upcoming.tabBarItem = upcomingTabBarItem
        setTabBarItemTextColor(upcomingTabBarItem)
        viewControllers = [ nowPlaying,
                            popular,
                            toprated,
                            upcoming
        ]
    }
    
    func setTabBarItemTextColor(_ tabBar: UITabBarItem) {
        let normalTabBarAttributes = [
            NSAttributedString.Key.foregroundColor: ThemeManager.tabBarUnSelectedTextColor
        ]
        let selectedTabBarAttributes = [
            NSAttributedString.Key.foregroundColor: ThemeManager.tabBarSelectedTextColor
        ]
        tabBar.setTitleTextAttributes(normalTabBarAttributes, for: .normal)
        tabBar.setTitleTextAttributes(selectedTabBarAttributes, for: .selected)
    }
    
    private func setupNavigationActionItems() {
        //Serach nav item
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        search.tintColor = ThemeManager.navTintColor
        navigationItem.rightBarButtonItem = search
        
        //Fav nav item
        let favoritesImage = UIImage(named: "favorites")
        let favorites = UIButton(type: .system)
        favorites.addTarget(self, action: #selector(favoritesTapped), for: .touchUpInside)
        favorites.setImage(favoritesImage, for: .normal)
        favorites.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let favoritesItem = UIBarButtonItem(customView: favorites)
        //add itesm to nav
        navigationItem.rightBarButtonItems = [search, favoritesItem]
    }
    
    @objc private func searchTapped() {
        self.navigationController?.pushViewController(GEMoviesSerachViewController(), animated: true)
    }
    
    @objc private func favoritesTapped() {
        self.navigationController?.pushViewController(GEFavoritesMoviesViewController(), animated: true)
    }
}
