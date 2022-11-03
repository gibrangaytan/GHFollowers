//
//  GHFReproItemViewController.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 11/2/22.
//

import UIKit

class GHFReproItemViewController: GHFItemInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoOne.setItemInfoType(type: .repos, withCount: user.publicRepos)
        itemInfoTwo.setItemInfoType(type: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    override func buttonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
