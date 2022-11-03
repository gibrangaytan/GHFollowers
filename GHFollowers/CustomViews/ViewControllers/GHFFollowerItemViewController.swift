//
//  GHFFollowerItemViewController.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 11/2/22.
//

import UIKit
class GHFFollowerItemViewController: GHFItemInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoOne.setItemInfoType(type: .followers, withCount: user.followers)
        itemInfoTwo.setItemInfoType(type: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func buttonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
