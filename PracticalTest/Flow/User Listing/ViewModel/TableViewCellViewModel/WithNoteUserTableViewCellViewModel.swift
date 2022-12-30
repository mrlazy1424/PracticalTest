//
//  WithNoteUserTableViewCellViewModel.swift
//  PracticalTest
//
//  Created by Parth Patel on 16/11/22.
//

import UIKit

class WithNoteUserTableViewCellViewModel: UserListTableViewCellModelProtocol {
    var cellIdentifier = "WithNoteUserTableViewCell"
    var objUserInfoModel: UserInfoModel?
    
    init(objUserInfoModel: UserInfoModel) {
        self.objUserInfoModel = objUserInfoModel
    }
}
