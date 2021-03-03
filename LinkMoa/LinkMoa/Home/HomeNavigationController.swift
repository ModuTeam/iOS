//
//  HomeNavigationController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import UIKit

final class HomeNavigationController: UINavigationController, BackGroundBlur {
    
    let addButtonView: UIView = {
        let addButtonView = UIView()
        addButtonView.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.backgroundColor = UIColor.init(rgb: 0x364788)
        addButtonView.layer.masksToBounds = true
        addButtonView.layer.cornerRadius = 63 / 2
        return addButtonView
    }()
    
    let plusImageView: UIImageView = {
        let plusImageView = UIImageView(image: UIImage(systemName: "plus"))
        plusImageView.tintColor = .white
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        return plusImageView
    }()
    
    let backGroundView: UIView = {
        let backGroundView: UIView = UIView()
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0
        backGroundView.isHidden = true
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        prepareNavigationBar()
        prepareAddButonView()
    }
    
    private func prepareNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: -3, right: 0))
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: -3, right: 0))
    }
    
    private func prepareAddButonView() {
        addButtonView.addSubview(plusImageView)
        view.addSubview(addButtonView)
        
        NSLayoutConstraint.activate([
            plusImageView.widthAnchor.constraint(equalToConstant: 28),
            plusImageView.heightAnchor.constraint(equalToConstant: 28),
            plusImageView.centerXAnchor.constraint(equalTo: addButtonView.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: addButtonView.centerYAnchor),
            addButtonView.widthAnchor.constraint(equalToConstant: 63),
            addButtonView.heightAnchor.constraint(equalToConstant: 63),
            addButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -39),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -39)
        ])
    }
    
    private func prepareBackGroundView() {
        view.addSubview(backGroundView)
        
        NSLayoutConstraint.activate([
            backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func removeBackGroundView() {
        backGroundView.subviews.forEach { $0.layer.removeAllAnimations() }
        backGroundView.layer.removeAllAnimations()
        backGroundView.removeFromSuperview()
        backGroundView.alpha = 0
    }
    
    func animateBackGroundView() { // 백그라운드 뷰 어둡게
        removeBackGroundView()
        prepareBackGroundView()
        backGroundView.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.backGroundView.alpha = 0.3
        })
    }
    
    func dismissBackGroundView() { // 백그라운드 뷰 밝게
        UIView.animate(withDuration: 0.4, animations: {
            self.backGroundView.alpha = 0
        }, completion: { _ in
            self.backGroundView.isHidden = true
            self.removeBackGroundView()
        })
    }
}

extension HomeNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
