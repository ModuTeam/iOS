//
//  RemoveSucceedBottomViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/20.
//

import UIKit

final class RemoveSucceedBottomViewController: UIViewController {

    @IBOutlet private var bottomView: UIView!
    @IBOutlet private var backGroundView: UIView!
    
    var completeHandler: (() -> ())?
    
    static func storyboardInstance() -> RemoveSucceedBottomViewController? {
        let storyboard = UIStoryboard(name: RemoveSucceedBottomViewController.storyboardName(), bundle: nil)
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
    
    private func preparebottomViewRoundConer() {
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bottomView.clipsToBounds = true
    }
    
    private func prepareBackGroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped))
        backGroundView.addGestureRecognizer(tapGesture)
        backGroundView.isUserInteractionEnabled = true
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
