//
//  SurfingViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/03.
//

import UIKit

final class SurfingViewController: UIViewController {

    static func storyboardInstance() -> SurfingViewController? {
        let storyboard = UIStoryboard(name: SurfingViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
