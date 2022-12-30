//
//  UserInfoModel.swift
//  PracticalTest
//
//  Created by Parth Patel on 15/11/22.
//

import Foundation

struct UserInfoModel : Codable {
    let login : String?
    let id : Int?
    let nodeID : String?
    let avatarURL : String?
    let gravatarID : String?
    let url : String?
    let htmlURL : String?
    let followersURL : String?
    let followingURL : String?
    let gistsURL : String?
    let starredURL : String?
    let subscriptionsURL : String?
    let organizationsURL : String?
    let reposURL : String?
    let eventsURL : String?
    let receivedEventsURL : String?
    let type : String?
    let siteAdmin : Bool?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url = "url"
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
        case type = "type"
        case siteAdmin = "site_admin"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try values.decodeIfPresent(String.self, forKey: .login)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.nodeID = try values.decodeIfPresent(String.self, forKey: .nodeID)
        self.avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
        self.gravatarID = try values.decodeIfPresent(String.self, forKey: .gravatarID)
        self.url = try values.decodeIfPresent(String.self, forKey: .url)
        self.htmlURL = try values.decodeIfPresent(String.self, forKey: .htmlURL)
        self.followersURL = try values.decodeIfPresent(String.self, forKey: .followersURL)
        self.followingURL = try values.decodeIfPresent(String.self, forKey: .followingURL)
        self.gistsURL = try values.decodeIfPresent(String.self, forKey: .gistsURL)
        self.starredURL = try values.decodeIfPresent(String.self, forKey: .starredURL)
        self.subscriptionsURL = try values.decodeIfPresent(String.self, forKey: .subscriptionsURL)
        self.organizationsURL = try values.decodeIfPresent(String.self, forKey: .organizationsURL)
        self.reposURL = try values.decodeIfPresent(String.self, forKey: .reposURL)
        self.eventsURL = try values.decodeIfPresent(String.self, forKey: .eventsURL)
        self.receivedEventsURL = try values.decodeIfPresent(String.self, forKey: .receivedEventsURL)
        self.type = try values.decodeIfPresent(String.self, forKey: .type)
        self.siteAdmin = try values.decodeIfPresent(Bool.self, forKey: .siteAdmin)
    }
    
    init(_ login : String?, id : Int, nodeID : String?, avatarURL : String?, gravatarID : String?, url : String?, htmlURL : String?, followersURL : String?, followingURL : String?, gistsURL : String?, starredURL : String?, subscriptionsURL : String?, organizationsURL : String?, reposURL : String?, eventsURL : String?, receivedEventsURL : String?, type : String?, siteAdmin : Bool) {
        self.login = login
        self.id = id
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.url = url
        self.htmlURL = htmlURL
        self.followersURL = followersURL
        self.followingURL = followingURL
        self.gistsURL = gistsURL
        self.starredURL = starredURL
        self.subscriptionsURL = subscriptionsURL
        self.organizationsURL = organizationsURL
        self.reposURL = reposURL
        self.eventsURL = eventsURL
        self.receivedEventsURL = receivedEventsURL
        self.type = type
        self.siteAdmin = siteAdmin
    }
}
