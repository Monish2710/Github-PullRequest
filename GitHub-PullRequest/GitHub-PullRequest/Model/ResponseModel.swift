//
//  ResponseModel.swift
//  GitHub-PullRequest
//
//  Created by Monish Kumar on 22/01/23.
//

import Foundation

// MARK: - ResponseElement

struct ResponseElement: Codable {
    let url: String?
    let id: Int?
    let nodeID: String?
    let htmlURL: String?
    let diffURL: String?
    let patchURL: String?
    let issueURL: String?
    let number: Int?
    let locked: Bool?
    let title: String?
    let user: User?
    let body: String?
    let createdAt, updatedAt: String?
    let requestedReviewers: [User]?
    let draft: Bool?
    let commitsURL, reviewCommentsURL: String?
    let commentsURL, statusesURL: String?
    let links: Links?
    let authorAssociation: String?

    enum CodingKeys: String, CodingKey {
        case url, id
        case nodeID = "node_id"
        case htmlURL = "html_url"
        case diffURL = "diff_url"
        case patchURL = "patch_url"
        case issueURL = "issue_url"
        case number, locked, title, user, body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case requestedReviewers = "requested_reviewers"
        case draft
        case commitsURL = "commits_url"
        case reviewCommentsURL = "review_comments_url"
        case commentsURL = "comments_url"
        case statusesURL = "statuses_url"
        case links = "_links"
        case authorAssociation = "author_association"
    }
}

// MARK: - User

struct User: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: TypeEnum
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

enum TypeEnum: String, Codable {
    case organization = "Organization"
    case user = "User"
}

// enum Visibility: String, Codable {
//    case visibilityPublic = "public"
// }

// MARK: - Links

struct Links: Codable {
    let linksSelf, html, issue, comments: Comments
    let reviewComments, reviewComment, commits, statuses: Comments

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, issue, comments
        case reviewComments = "review_comments"
        case reviewComment = "review_comment"
        case commits, statuses
    }
}

// MARK: - Comments

struct Comments: Codable {
    let href: String
}

typealias Response = [ResponseElement]
