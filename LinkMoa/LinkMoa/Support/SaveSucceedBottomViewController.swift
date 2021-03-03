//
//  SaveSucceedBottomViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/20.
//

import UIKit

final class SaveSucceedBottomViewController: UIViewController {

    @IBOutlet private weak var backGroundView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    
    var completeHandler: (() -> ())?

    static func storyboardInstance() -> SaveSucceedBottomViewController? {
        let storyboard = UIStoryboard(name: SaveSucceedBottomViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareBackGroundView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preparebottomViewRoundConer()
    }
    
    private func prepareBackGroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped))
        backGroundView.addGestureRecognizer(tapGesture)
        backGroundView.isUserInteractionEnabled = true
    }
    
    private func preparebottomViewRoundConer() {
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bottomView.clipsToBounds = true
    }
    
    @objc private func backGroundViewTapped() {
        completeHandler?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissButtonTapped() {
        completeHandler?()
        dismiss(animated: true, completion: nil)
    }
}
