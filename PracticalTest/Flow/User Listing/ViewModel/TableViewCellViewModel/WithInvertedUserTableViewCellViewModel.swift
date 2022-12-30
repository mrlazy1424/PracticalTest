//
//  WithInvertedUserTableViewCellViewModel.swift
//  PracticalTest
//
//  Created by Parth Patel on 27/10/22.
//

import UIKit

class WithInvertedUserTableViewCellViewModel: UserListTableViewCellModelProtocol {
    var cellIdentifier = "WithInvertedUserTableViewCell"
    var objUserInfoModel: UserInfoModel?
    
    init(objUserInfoModel: UserInfoModel) {
        self.objUserInfoModel = objUserInfoModel
    }
}
