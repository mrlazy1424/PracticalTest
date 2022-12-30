//
//  UserTableViewCell.swift
//  PracticalTest
//
//  Created by Parth Patel on 15/11/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - All Outlets
    @IBOutlet weak var ibShadowView: UIView!
    @IBOutlet weak var ibContainerView: UIView!
    @IBOutlet weak var ibProfileImageShadowView: UIView!
    @IBOutlet weak var ibProfileImageView: LazyImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDetailsURL: UILabel!
    
    //MARK: - All Properties and Variables
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    private let placeHolderImage = #imageLiteral(resourceName: "userProfile")
    
    //MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellThemeConfig()
    }
    
    //MARK: - Self Calling Methods
    private func cellThemeConfig() {
        self.ibShadowView.addShadowToView(.black, shadowOpacity: 0.2, shadowOffset: .zero, shadowRadius: 5)
        self.ibShadowView.layer.cornerRadius = 5
        self.ibShadowView.clipsToBounds = false
        self.ibContainerView.layer.cornerRadius = 5
        self.ibContainerView.clipsToBounds = true
        
        self.ibProfileImageShadowView.addShadowToView(.black, shadowOpacity: 0.6, shadowOffset: .zero, shadowRadius: 5)
        self.ibProfileImageShadowView.layer.cornerRadius = self.ibProfileImageShadowView.frame.size.height/2
        self.ibProfileImageView.layer.cornerRadius = self.ibProfileImageShadowView.frame.size.height/2
    }
}

//MARK: -
//MARK: - All Extensions
//MARK: -

extension UserTableViewCell: UserListTableViewCellProtocol {
    func configUserCellData(_ cellData: UserListTableViewCellModelProtocol?) {
        if let cellData = cellData as? UserTableViewCellViewModel {
            self.lblUserName.text = cellData.objUserInfoModel?.login ?? ""
            self.lblUserDetailsURL.text = cellData.objUserInfoModel?.gistsURL ?? ""
            
            if let url = URL(string: cellData.objUserInfoModel?.avatarURL ?? "") {
                self.ibProfileImageView.loadImage(url, placeHolderImage: self.placeHolderImage, isInvertedImage: false)
            }
        }
    }
}
