//
//  GHFFavoritesListViewController.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 10/20/22.
//

import UIKit

class GHFFavoritesListViewController: UIViewController {
    
    let tableView = UITableView()
    var favorites: [GHFFollower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(GHFFavoriteCell.self, forCellReuseIdentifier: GHFFavoriteCell.reuseID)
    }
    
    func getFavorites() {
        GHFPersistanceManager.retreiveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No favorites?\nAdd one on the follower screen.", in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTittle: "Ok")
            }
        }
    }
}

extension GHFFavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GHFFavoriteCell.reuseID) as! GHFFavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followerListViewController = GHFFollowersListViewController()
        followerListViewController.username = favorite.login
        followerListViewController.title = favorite.login
        navigationController?.pushViewController(followerListViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        GHFPersistanceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self ]error in
            guard let self = self else { return }
            guard let error = error else {return }
            self.presentGHFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTittle: "Ok")
        }
    }
}
