//
//  TableViewCellProtocols.swift
//  PracticalTest
//
//  Created by Parth Patel on 16/11/22.
//

import UIKit

protocol UserListTableViewCellProtocol {
    func configUserCellData(_ cellData: UserListTableViewCellModelProtocol?)
}

protocol UserListTableViewCellModelProtocol {
    var cellIdentifier: String { get }
}
