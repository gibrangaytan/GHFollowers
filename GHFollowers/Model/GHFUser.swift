//
//  GHFUser.swift
//  GHFollowers
//
//  Created by GIBRAN I GAYTAN SILVA on 10/31/22.
//

import Foundation

struct GHFUser: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let followers: Int
    let following: Int
    let createdAt: String
}
