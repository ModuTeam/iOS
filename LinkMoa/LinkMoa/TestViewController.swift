//
//  TestViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/17.
//

import UIKit

class TestViewController: UIViewController {

    let link = LinkPresentaionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        link.fetchLinkMetaData(urlString: "https://www.naver.com", completionHandler: { web, icon in
            print("------>", web, icon)
        })
        // Do any additional setup after loading the view.
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
