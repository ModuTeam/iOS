//
//  ReportBottomViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/16.
//

import UIKit

class ReportBottomViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var reportButtonView: UIView!
    
    var folderIndex: Int?
    var completionHandler: (() -> ())?
    var removeHandler: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackGroundView()
        prepareBottomViewGesture()
        prepareDeleteButtonView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareBottomViewRoundConer()
    }

    static func storyboardInstance() -> ReportBottomViewController? {
        let storyboard = UIStoryboard(name: ReportBottomViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareDeleteButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reportButtonViewTapped))
        reportButtonView.addGestureRecognizer(tapGesture)
        reportButtonView.isUserInteractionEnabled = true
        
        reportButtonView.layer.masksToBounds = true
        reportButtonView.layer.cornerRadius = 8
        reportButtonView.layer.borderWidth = 1
        reportButtonView.layer.borderColor = UIColor.linkMoaRedColor.cgColor
    }
    
    private func prepareBottomViewRoundConer() {
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bottomView.clipsToBounds = true
    }
    
    private func prepareBottomViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomViewTapped))
        tapGesture.cancelsTouchesInView = false
        bottomView.addGestureRecognizer(tapGesture)
        bottomView.isUserInteractionEnabled = true
    }
    
    private func prepareBackGroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    @objc private func reportButtonViewTapped() {
        
        self.completionHandler?()
        
        dismiss(animated: true, completion: {
            self.removeHandler?()
        })
        
    }
    
    @objc private func backgroundViewTapped() {
        completionHandler?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func bottomViewTapped() {
        
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        completionHandler?()
        dismiss(animated: true, completion: nil)
    }
    
}

