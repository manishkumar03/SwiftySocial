//
//  GithubUserInfo.swift
//  
//
//  Created by Manish Kumar on 2023-03-11.
//

import Foundation

// MARK: - GithubUserInfo

/// Structure of the `user info` API response
struct GithubUserInfo: Codable {
    let login: String
    let id: Int
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
    let name: String
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: Bool?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: String
    let updatedAt: String
    let privateGists: Int
    let totalPrivateRepos: Int
    let ownedPrivateRepos: Int
    let diskUsage: Int
    let collaborators: Int
    let twoFactorAuthentication: Bool
    let plan: Plan
}

// MARK: - Plan
struct Plan: Codable {
    let name: String
    let space: Int
    let collaborators: Int
    let privateRepos: Int
}
