//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 11/2/22.
//

import UIKit
import SafariServices

protocol GHFUserInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile(for user: GHFUser)
    func didTapGetFollowers(for user: GHFUser)
}

class GHFUserInfoViewController: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GHFBodyLabel(textAlignment: .center)
    
    let padding: CGFloat = 20

    var userName: String!
    weak var delegate: GHFFollowersListViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureHeaderView()
        configureItemViewOne()
        configureItemViewTwo()
        configureDateLabel()
        getUserData()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func configureItemViewOne() {
        view.addSubview(itemViewOne)
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    func configureItemViewTwo() {
        view.addSubview(itemViewTwo)
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    func configureDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func getUserData() {
        GHFNetworkManager.shared.getUserInfo(for: userName) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.configureUIElements(with: user)
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something happened!", message: error.rawValue, buttonTittle: "Ok")
            }
        }
    }
    
    func configureUIElements(with user: GHFUser) {
        DispatchQueue.main.async {
            self.add(child: GHFUserInfoHeaderViewController(user: user), to: self.headerView)
            
            let repoItemViewController = GHFReproItemViewController(user: user)
            repoItemViewController.delegate = self
            self.add(child: repoItemViewController, to: self.itemViewOne)
            
            let followersItemViewController = GHFFollowerItemViewController(user: user)
            followersItemViewController.delegate = self
            self.add(child: followersItemViewController, to: self.itemViewTwo)
            
            self.dateLabel.text = "GitHub memeber since \(user.createdAt.convertToDisplayFormat())"
        }
    }
    
    func add(child: UIViewController, to view: UIView){
        addChild(child)
        view.addSubview(child.view)
        child.view.frame = view.bounds
        child.didMove(toParent: self)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}

extension GHFUserInfoViewController: GHFUserInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: GHFUser) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGHFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTittle: "Ok")
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredBarTintColor = .systemGreen
        present(safariViewController, animated: true)
    }
    
    func didTapGetFollowers(for user: GHFUser) {
        guard user.followers != 0 else {
            presentGHFAlertOnMainThread(title: "No Follower", message: "This user has no followers 😔.", buttonTittle: "Ok")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissViewController()
    }
}
