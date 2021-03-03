//
//  LoginViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/08.
//

import UIKit
import Lottie

final class LoginViewController: UIViewController {

    @IBOutlet private weak var startButtonView: UIView!
    @IBOutlet private weak var animationBaseView: UIView!
    @IBOutlet private weak var privateRuleLabel: UILabel!
    @IBOutlet private weak var useRuleLabel: UILabel!
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "edit_garibi")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 375)
        animationView.loopMode = .loop
        return animationView
    }()
    
    deinit {
        print("okay?")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareRuleLabels()
        prepareStartButtonView()
        prepareAnimationView()
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    private func prepareRuleLabels() {
        let privateUnderlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let privateUnderlineAttributedString = NSAttributedString(string: "개인정보처리방침", attributes: privateUnderlineAttribute)
        privateRuleLabel.attributedText = privateUnderlineAttributedString
        
        let useUnderlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let useUnderlineAttributedString = NSAttributedString(string: "이용약관", attributes: useUnderlineAttribute)
        useRuleLabel.attributedText = useUnderlineAttributedString
    }

    private func prepareAnimationView() {
        animationBaseView.addSubview(animationView)
    }
    
    private func prepareStartButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startButtonTapped))
        startButtonView.addGestureRecognizer(tapGesture)
        startButtonView.isUserInteractionEnabled = true
        
        startButtonView.layer.masksToBounds = true
        startButtonView.layer.cornerRadius = 8
    }
    
    @objc private func restartAnimation() {
        animationView.play()
    }
    
    @objc private func startButtonTapped() {
        guard let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as? HomeNavigationController,
              let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }

        window.rootViewController = homeVC
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
