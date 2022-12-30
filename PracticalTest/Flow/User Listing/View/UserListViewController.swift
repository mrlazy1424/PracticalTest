//
//  UserListViewController.swift
//  PracticalTest
//
//  Created by Parth Patel on 15/11/22.
//

import UIKit

class UserListViewController: UIViewController {
    
    //MARK: - All Outlets
    @IBOutlet weak var ibUserListTableView: UITableView!
    @IBOutlet weak var ibNoInternetContainerView: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK: - All Properties and Variables
    fileprivate var objUserListViewModel: UserListViewModel?
    fileprivate var refreshControl = UIRefreshControl()
    
    //MARK: - Page Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.ibUserListTableView.windless
            .apply {
                $0.beginTime = 0.01
                $0.duration = 4
                $0.animationLayerOpacity = 0.5
            }
            .start()
        
        self.initViewModel()
        self.addPullToRefresh()
        self.updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusManager), name: .flagsChanged, object: nil)
        self.objUserListViewModel?.refreshUserList()
        self.reloadTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: nil)
    }
    
    //MARK: - Self Calling Methods
    private func initView() {
        self.ibUserListTableView.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.identifier)
        self.ibUserListTableView.register(WithInvertedUserTableViewCell.nib, forCellReuseIdentifier: WithInvertedUserTableViewCell.identifier)
        self.ibUserListTableView.register(WithNoteUserTableViewCell.nib, forCellReuseIdentifier: WithNoteUserTableViewCell.identifier)
    }
    
    private func initViewModel() {
        self.objUserListViewModel = UserListViewModel(self)
        self.objUserListViewModel?.reloadTableData = {
            self.reloadTableView()
            self.refreshControl.endRefreshing()
            self.ibUserListTableView.windless.end()
            if self.objUserListViewModel?.objUserListTableViewCellModelProtocolArray.count ?? 0 > 0 {
                self.lblNoData.isHidden = true
            } else {
                self.lblNoData.isHidden = false
            }
        }
        self.objUserListViewModel?.callAPIForGetUserList(true, isShowLoadingIndicator: false)
    }
    
    private func addPullToRefresh() {
        //Add pull to refresh
        self.refreshControl.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 0.7)
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.ibUserListTableView.addSubview(self.refreshControl)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.objUserListViewModel?.callAPIForGetUserList(true, isShowLoadingIndicator: true)
    }
    
    @objc func statusManager(_ notification: Notification) {
        self.updateUserInterface()
        if self.objUserListViewModel?.objUserListTableViewCellModelProtocolArray.count == 0 {
            self.objUserListViewModel?.callAPIForGetUserList(true, isShowLoadingIndicator: true)
        }
    }
    
    private func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            self.ibNoInternetContainerView.backgroundColor = .red
            self.ibNoInternetContainerView.isHidden = false
        case .wwan,.wifi:
            self.ibNoInternetContainerView.isHidden = true
        }
        self.reloadTableView()
    }
    
    private func reloadTableView() {
        self.objUserListViewModel?.refreshUserList()
        self.ibUserListTableView.reloadData()
    }
    
    //MARK: - Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetails" {
            let objUserDetailsViewController = segue.destination as! UserDetailsViewController
            objUserDetailsViewController.currentSelectedUserID = self.objUserListViewModel?.currentSelectedUserID ?? ""
        }
    }
}

//MARK: -
//MARK: - All Extensions
//MARK: -

//MARK: - UITableView Delegate and DataSource Methods
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objUserListViewModel == nil {
            return 10
        }
        return self.objUserListViewModel?.objUserListTableViewCellModelProtocolArray.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else { fatalError("xib does not exists") }
//        cell.configUserCell(self.objUserListViewModel?.objUserListTableViewCellModelProtocolArray[indexPath.row])
//        return cell
        
        
        
        let objCellViewModel = self.objUserListViewModel?.objUserListTableViewCellModelProtocolArray[indexPath.row]        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: objCellViewModel?.cellIdentifier ?? UserTableViewCell.identifier) as? UserListTableViewCellProtocol else {
            fatalError("xib does not exists")
        }
        cell.configUserCellData(objCellViewModel)
        return cell as? UITableViewCell ?? UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ConnectivityManager.shared.isInternetAvailable() {
            self.objUserListViewModel?.redirectToUserDetailsView(indexPath)
        } else {
            if self.objUserListViewModel?.checkOfflineUserDetailsAvailable(indexPath) ?? false {
                self.objUserListViewModel?.redirectToUserDetailsView(indexPath)
            } else {
                self.showAlertView("Alert", message: "Profile details not available for offline ", buttonName: "Ok")
            }
        }
    }
}

//MARK: - UIScrollView Delegate Methods
extension UserListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ConnectivityManager.shared.isInternetAvailable() {
            guard (self.objUserListViewModel?.objUserListTableViewCellModelProtocolArray.count ?? 0) > 0, scrollView == self.ibUserListTableView,
                  (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 300,
                  (self.objUserListViewModel?.isFetchingUsersList ?? false) == false else { return }
            self.objUserListViewModel?.callAPIForGetUserList(false, isShowLoadingIndicator: true)
        }
    }
}
