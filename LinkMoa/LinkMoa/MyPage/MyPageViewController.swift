//
//  MyPageViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/16.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    private let menus: [String] = ["FAQ", "건의&불편신고", "버전정보", "탈퇴하기"]
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMenuTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationBar()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    static func storyboardInstance() -> MyPageViewController? {
        let storyboard = UIStoryboard(name: MyPageViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
    }

    private func prepareMenuTableView() {
        let nib = UINib(nibName: MyPageCell.cellIdentifier, bundle: nil)
        menuTableView.register(nib, forCellReuseIdentifier: MyPageCell.cellIdentifier)
        menuTableView.dataSource = self
        menuTableView.delegate = self
    }

}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myPageCell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.cellIdentifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
        myPageCell.titleLabel.text = menus[indexPath.row]
        if indexPath.row == 2 {
            myPageCell.subTitleLabel.isHidden = false
        }
        return myPageCell
    }
    
    
}

extension MyPageViewController: UITableViewDelegate {
}
