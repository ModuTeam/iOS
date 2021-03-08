//
//  ViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/01/28.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func home() {
        guard let homeVc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as? UINavigationController else { return }
        
        homeVc.modalPresentationStyle = .fullScreen
        present(homeVc, animated: true)
    }
    
    @IBAction func login() {
        guard let loginVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else { return }
        
        loginVc.modalPresentationStyle = .fullScreen
        present(loginVc, animated: true)
    }
    
    @IBAction func test() {
        guard let testVc = UIStoryboard(name: "Test", bundle: nil).instantiateInitialViewController() as? TestViewController else { return }
        
        present(testVc, animated: true)
    }
}

