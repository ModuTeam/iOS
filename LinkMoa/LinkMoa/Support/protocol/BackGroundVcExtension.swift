//
//  BackGroundVcExtension.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/24.
//

import UIKit

protocol BackGroundBlur: UIViewController {}

extension BackGroundBlur where Self: UIViewController {
    
    private func makeBackGroundView() -> UIView {
        let backGroundView: UIView = UIView()
        backGroundView.tag = 20
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0
        backGroundView.isHidden = false
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundView
    }
    
    func startBackGroundView() {
        let backGroundView = makeBackGroundView()
        view.addSubview(backGroundView)
        
        NSLayoutConstraint.activate([
            backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.4, animations: {
            backGroundView.alpha = 0.3
        })
    }
    
    func stopBackGroundView() {
        guard let backGroundView = view.subviews.filter({$0.tag == 20}).first else { return }
        UIView.animate(withDuration: 0.4, animations: {
            backGroundView.alpha = 0
        }, completion: { _ in
            backGroundView.subviews.forEach { $0.layer.removeAllAnimations() }
            backGroundView.layer.removeAllAnimations()
            backGroundView.removeFromSuperview()
        })
    }
}

extension BackGroundBlur where Self: UINavigationController {
    
    private func makeBackGroundView() -> UIView {
        let backGroundView: UIView = UIView()
        backGroundView.tag = 20
        backGroundView.backgroundColor = UIColor.black
        backGroundView.alpha = 0
        backGroundView.isHidden = false
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundView
    }
    
    func animateBackGroundView() {
        let backGroundView = makeBackGroundView()
        view.addSubview(backGroundView)
        
        NSLayoutConstraint.activate([
            backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backGroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.4, animations: {
            backGroundView.alpha = 0.3
        })
    }
    
    func removeBackGroundView() {
        guard let backGroundView = view.subviews.filter({$0.tag == 20}).first else { return }
        UIView.animate(withDuration: 0.4, animations: {
            backGroundView.alpha = 0
        }, completion: { _ in
            backGroundView.subviews.forEach { $0.layer.removeAllAnimations() }
            backGroundView.layer.removeAllAnimations()
            backGroundView.removeFromSuperview()
        })
    }
}
