//
//  UserDetailsViewModel.swift
//  PracticalTest
//
//  Created by Parth Patel on 18/11/22.
//

import UIKit
import Combine

class UserDetailsViewModel {
    private var cancellables = Set<AnyCancellable>()
    var objUserDetailsModel: UserDetailsModel?
    var error: Error?
    private var userDetailsController = UIViewController()
    var reloadData: (() -> Void)?
    
    required init(_ viewController: UIViewController) {
        self.userDetailsController = viewController
    }
    
    func callAPIForGetUserDetails(_ userID: String) {
        if ConnectivityManager.shared.isInternetAvailable() {
            self.userDetailsController.showLoadingIndicator()
            NetworkManager.shared.getData(endpoint: .getUserDetails(userID: userID), type: UserDetailsModel.self)
                .sink { completion in
                    switch completion {
                    case .failure(let err):
                        print("Error is \(err.localizedDescription)")
                        self.error = err
                    case .finished:
                        print("Finished")
                        self.userDetailsController.hideLoadingIndicator()
                    }
                }
                receiveValue: { [weak self] UserDetails in
                    CoreDataManager.shared.saveUserDetailsData(UserDetails)
                    self?.objUserDetailsModel = UserDetails
                    self?.reloadData!()
                }
                .store(in: &cancellables)
        } else {
            if let objUserDetailsCDModel = CoreDataManager.shared.getUserDetails(userID) {
                self.objUserDetailsModel = self.convertCoreDataModelIntoCodableModel(objUserDetailsCDModel)
            }
            self.reloadData!()
        }
    }
    
    func getNote(_ userID: String) -> String {
        return CoreDataManager.shared.getNote(userID)?.notes ?? ""
    }
    
    private func convertCoreDataModelIntoCodableModel(_ objUserDetailsCDModel: UserDetailsCDModel) -> UserDetailsModel {
        
        let objTempUserDetailsModel = UserDetailsModel(objUserDetailsCDModel.login, id: Int(objUserDetailsCDModel.id), nodeID: objUserDetailsCDModel.node_id, avatarURL: objUserDetailsCDModel.avatar_url, gravatarID: objUserDetailsCDModel.gravatar_id, url: objUserDetailsCDModel.url, htmlURL: objUserDetailsCDModel.html_url, followersURL: objUserDetailsCDModel.followers_url, followingURL: objUserDetailsCDModel.following_url, gistsURL: objUserDetailsCDModel.gists_url, starredURL: objUserDetailsCDModel.starred_url, subscriptionsURL: objUserDetailsCDModel.subscriptions_url, organizationsURL: objUserDetailsCDModel.organizations_url, reposURL: objUserDetailsCDModel.repos_url, eventsURL: objUserDetailsCDModel.events_url, receivedEventsURL: objUserDetailsCDModel.received_events_url, type: objUserDetailsCDModel.type, siteAdmin: objUserDetailsCDModel.site_admin, name: objUserDetailsCDModel.name, company: objUserDetailsCDModel.company, blog: objUserDetailsCDModel.blog, location: objUserDetailsCDModel.location, email: objUserDetailsCDModel.email, hireable: objUserDetailsCDModel.hireable, bio: objUserDetailsCDModel.bio, twitterUsername: objUserDetailsCDModel.twitter_username, publicRepos: Int(objUserDetailsCDModel.public_repos), publicGists: Int(objUserDetailsCDModel.public_gists), followers: Int(objUserDetailsCDModel.followers), following: Int(objUserDetailsCDModel.following), createdAT: objUserDetailsCDModel.created_at, updatedAT: objUserDetailsCDModel.updated_at)
        return objTempUserDetailsModel
    }
}
