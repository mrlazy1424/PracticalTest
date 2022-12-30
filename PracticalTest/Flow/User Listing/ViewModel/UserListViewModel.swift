//
//  UserListViewModel.swift
//  PracticalTest
//
//  Created by Parth Patel on 16/11/22.
//

import UIKit
import Combine

class UserListViewModel {
    private var cancellables = Set<AnyCancellable>()
    private var objUserInfoModelArray = [UserInfoModel]()
    var objUserListTableViewCellModelProtocolArray = [UserListTableViewCellModelProtocol]()
    var error: Error?
    
    private var userViewController = UIViewController()
    var reloadTableData: (() -> Void)?
    var currentSelectedUserID = ""
    var isFetchingUsersList = false
    
    required init(_ viewController: UIViewController) {
        self.userViewController = viewController
    }
    
    func callAPIForGetUserList(_ isFromStarting: Bool, isShowLoadingIndicator: Bool) {
        if ConnectivityManager.shared.isInternetAvailable() {
            if isShowLoadingIndicator {
                self.userViewController.showLoadingIndicator()
            }
            self.isFetchingUsersList = true
            var lastUserID = "0"
            if isFromStarting {
                lastUserID = "0"
            } else {
                lastUserID = self.objUserInfoModelArray.count > 0 ? "\((self.objUserInfoModelArray.last?.id ?? 0))" : "0"
            }
            
            NetworkManager.shared.getData(endpoint: .getUserList(lastUserID: lastUserID), type: [UserInfoModel].self)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error is \(error.localizedDescription)")
                        self.error = error
                    case .finished:
                        print("Finished")
                    }
                    if isShowLoadingIndicator {
                        self.userViewController.hideLoadingIndicator()
                    }
                }
                receiveValue: { [weak self] objUserInfoData in
                    
                    for objUserInfoModel in objUserInfoData {
                        CoreDataManager.shared.saveUserListData(objUserInfoModel)
                    }
                    if isFromStarting {
                        self?.objUserInfoModelArray = objUserInfoData
                    } else {
                        if let tempUserData = self?.objUserInfoModelArray, tempUserData.count > 0 {
                            self?.objUserInfoModelArray.append(contentsOf: objUserInfoData)
                        } else {
                            self?.objUserInfoModelArray = objUserInfoData
                        }
                    }
                    self?.setUserListData(objUserInfoData)
                    self?.reloadTableData!()
                    self?.isFetchingUsersList = false
                }
                .store(in: &self.cancellables)
        } else {
            let objUserInfoModelArray = CoreDataManager.shared.getAllUsersList()
            if objUserInfoModelArray.count > 0 {
                self.objUserInfoModelArray = self.convertCoreDataModelIntoCodableModel(objUserInfoModelArray)
                self.setUserListData(self.objUserInfoModelArray)
            } else {
                print("No users in the core data")
            }
            self.reloadTableData!()
            self.isFetchingUsersList = false
        }
    }
    
    private func convertCoreDataModelIntoCodableModel(_ objUserInfoModelArray: [UserListModel]) -> [UserInfoModel] {
        var tempObjUserInfoModelArray = [UserInfoModel]()
        for objUserListCDModel in objUserInfoModelArray {
            let tempObjUserInfoModel = UserInfoModel(objUserListCDModel.login, id: Int(objUserListCDModel.id), nodeID: objUserListCDModel.node_id, avatarURL: objUserListCDModel.avatar_url, gravatarID: objUserListCDModel.gravatar_id, url: objUserListCDModel.url, htmlURL: objUserListCDModel.html_url, followersURL: objUserListCDModel.followers_url, followingURL: objUserListCDModel.following_url, gistsURL: objUserListCDModel.gists_url, starredURL: objUserListCDModel.starred_url, subscriptionsURL: objUserListCDModel.subscriptions_url, organizationsURL: objUserListCDModel.organizations_url, reposURL: objUserListCDModel.repos_url, eventsURL: objUserListCDModel.events_url, receivedEventsURL: objUserListCDModel.received_events_url, type: objUserListCDModel.type, siteAdmin: objUserListCDModel.site_admin)
            
            tempObjUserInfoModelArray.append(tempObjUserInfoModel)
        }
        return tempObjUserInfoModelArray
    }
    
    func checkOfflineUserDetailsAvailable(_ selecteAtIndex: IndexPath) -> Bool {
        if let _ = CoreDataManager.shared.getUserDetails(self.objUserInfoModelArray[selecteAtIndex.row].login ?? "") {
            return true
        } else {
            return false
        }
    }
    
    func refreshUserList() {
        self.setUserListData(self.objUserInfoModelArray)
    }
    
    func redirectToUserDetailsView(_ selecteAtIndex: IndexPath) {
        self.currentSelectedUserID = self.objUserInfoModelArray[selecteAtIndex.row].login ?? ""
        self.userViewController.performSegue(withIdentifier: "userDetails", sender: self.userViewController)
    }
    
    //MARK: -
    private func setUserListData(_ objUserInfoModelArray: [UserInfoModel]) {
        self.objUserListTableViewCellModelProtocolArray.removeAll()
        
        for (index, objUserInfoModel) in objUserInfoModelArray.enumerated() {
            if let objNotesCDModel = CoreDataManager.shared.getNote(objUserInfoModel.login ?? ""), (objNotesCDModel.notes ?? "") != "" {
                self.objUserListTableViewCellModelProtocolArray.append(WithNoteUserTableViewCellViewModel(objUserInfoModel: objUserInfoModel))
            } else {
                if (index % 4) == 0 {
                    self.objUserListTableViewCellModelProtocolArray.append(WithInvertedUserTableViewCellViewModel(objUserInfoModel: objUserInfoModel))
                } else {
                    self.objUserListTableViewCellModelProtocolArray.append(UserTableViewCellViewModel(objUserInfoModel: objUserInfoModel))
                }
            }
        }
    }
}
