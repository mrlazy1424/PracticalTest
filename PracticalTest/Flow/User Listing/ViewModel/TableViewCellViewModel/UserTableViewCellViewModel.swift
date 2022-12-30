//
//  UserTableViewCellViewModel.swift
//  PracticalTest
//
//  Created by Parth Patel on 16/11/22.
//

import Foundation

class UserTableViewCellViewModel: UserListTableViewCellModelProtocol {
    var cellIdentifier = "UserTableViewCell"
    var objUserInfoModel: UserInfoModel?
    
    init(objUserInfoModel: UserInfoModel) {
        self.objUserInfoModel = objUserInfoModel
    }
}
