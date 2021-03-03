//
//  HomeNavigationController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import UIKit

final class HomeNavigationController: UINavigationController, BackgroundBlur {
    
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
    
    let backgroundView: UIView = {
        let backgroundView: UIView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        backgroundView.isHidden = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
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
    
    private func prepareBackgroundView() {
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func removeBackgroundView() {
        backgroundView.subviews.forEach { $0.layer.removeAllAnimations() }
        backgroundView.layer.removeAllAnimations()
        backgroundView.removeFromSuperview()
        backgroundView.alpha = 0
    }
    
    func animateBackgroundView() { // 백그라운드 뷰 어둡게
        removeBackgroundView()
        prepareBackgroundView()
        backgroundView.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundView.alpha = 0.3
        })
    }
    
    func dismissBackgroundView() { // 백그라운드 뷰 밝게
        UIView.animate(withDuration: 0.4, animations: {
            self.backgroundView.alpha = 0
        }, completion: { _ in
            self.backgroundView.isHidden = true
            self.removeBackgroundView()
        })
    }
}

extension HomeNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
