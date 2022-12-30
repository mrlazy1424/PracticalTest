//
//  UserDetailsViewController.swift
//  PracticalTest
//
//  Created by Parth Patel on 15/11/22.
//

import UIKit

class UserDetailsViewController: UIViewController {

    //MARK: - All Outlets
    @IBOutlet weak var ibNoInternetContainerView: UIView!
    @IBOutlet weak var ibProfileImageView: LazyImageView!
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompanyTitle: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlogTitle: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var lblFollowersTitle: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowingTitle: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblNotesTitle: UILabel!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var ibSaveBtn: UIButton!
    
    //MARK: - All Properties and Variables
    var currentSelectedUserID = ""
    private var objUserDetailsViewModel: UserDetailsViewModel?
    private let placeHolder = #imageLiteral(resourceName: "userProfile")
    
    //MARK: - Page Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.themeConfig()
        self.objUserDetailsViewModel?.callAPIForGetUserDetails(self.currentSelectedUserID)
        self.updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusManager), name: .flagsChanged, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: nil)
    }
    
    //MARK: - All Actions
    @IBAction func btnSave(_ sender: UIButton) {
        var title = ""
        var message = ""
        if CoreDataManager.shared.saveNote(self.currentSelectedUserID, notes: self.txtNotes.text) {
            title = "Success"
            message = "Note saved."
        } else {
            title = "Alert"
            message = "Note not saved."
        }
        
        self.showAlertView(title, message: message, buttonName: "Ok")
    }
    
    //MARK: - Self Calling Methods
    private func initViewModel() {
        self.objUserDetailsViewModel = UserDetailsViewModel(self)
        self.objUserDetailsViewModel?.reloadData = {
            self.setData()
        }
    }
    
    private func themeConfig() {
        self.ibProfileImageView.layer.cornerRadius = self.ibProfileImageView.frame.width/2
        self.txtNotes.layer.cornerRadius = 10
        self.txtNotes.layer.borderWidth = 1
        self.txtNotes.layer.borderColor = UIColor.gray.cgColor
        self.ibSaveBtn.layer.cornerRadius = self.ibSaveBtn.frame.height/2
    }
    
    private func setData() {
        if let profileImageURL = URL(string: self.objUserDetailsViewModel?.objUserDetailsModel?.avatarURL ?? "")  {
            self.ibProfileImageView.loadImage(profileImageURL, placeHolderImage: self.placeHolder, isInvertedImage: false)
        }
        
        self.lblName.text = self.objUserDetailsViewModel?.objUserDetailsModel?.name ?? "-"
        self.lblCompany.text = self.objUserDetailsViewModel?.objUserDetailsModel?.company ?? "-"
        self.lblBlog.text = self.objUserDetailsViewModel?.objUserDetailsModel?.blog ?? "-"
        self.lblFollowers.text = "\((self.objUserDetailsViewModel?.objUserDetailsModel?.followers ?? 0))"
        self.lblFollowing.text = "\((self.objUserDetailsViewModel?.objUserDetailsModel?.following ?? 0))"
        
        self.lblNameTitle.text = "Name:"
        self.lblCompanyTitle.text = "Company:"
        self.lblBlogTitle.text = "Blog:"
        self.lblFollowersTitle.text = "Followers:"
        self.lblFollowersTitle.text = "Followers:"
        self.lblNotesTitle.text = "Notes:"
        
        self.txtNotes.text = self.objUserDetailsViewModel?.getNote(self.currentSelectedUserID)
    }
    
    @objc func statusManager(_ notification: Notification) {
        self.updateUserInterface()
        self.objUserDetailsViewModel?.callAPIForGetUserDetails(self.currentSelectedUserID)
    }
    
    private  func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            self.ibNoInternetContainerView.backgroundColor = .red
            self.ibNoInternetContainerView.isHidden = false
        case .wwan,.wifi:
            self.ibNoInternetContainerView.isHidden = true
        }
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
