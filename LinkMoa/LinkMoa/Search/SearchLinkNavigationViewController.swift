//
//  SearchNavigationViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/26.
//

import UIKit

class SearchFolderNavigationViewController: UINavigationController, BackGroundBlur {

    static func storyboardInstance() -> SearchFolderNavigationViewController? {
        let storyboard = UIStoryboard(name: SearchFolderNavigationViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        prepareNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    private func prepareNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: -3, right: 0))
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: -3, right: 0))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchFolderNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
