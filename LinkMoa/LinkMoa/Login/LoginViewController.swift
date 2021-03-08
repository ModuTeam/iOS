//
//  LoginViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/08.
//

import UIKit
import Lottie
import AuthenticationServices

final class LoginViewController: UIViewController {

    @IBOutlet private weak var startButtonView: UIView!
    @IBOutlet private weak var appleLoginStackView: UIStackView!
    @IBOutlet private weak var animationBaseView: UIView!
    @IBOutlet private weak var privateRuleLabel: UILabel!
    @IBOutlet private weak var useRuleLabel: UILabel!
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "edit_garibi")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 375)
        animationView.loopMode = .loop
        return animationView
    }()
    
    private let loginViewModel = LoginViewModel()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareAppleLoginStackView()
        prepareRuleLabels()
        prepareStartButtonView()
        prepareAnimationView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    private func prepareAppleLoginStackView() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        appleLoginStackView.addArrangedSubview(button)
        
        appleLoginStackView.layer.masksToBounds = true
        appleLoginStackView.layer.cornerRadius = 8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLoginStackViewTapped))
        appleLoginStackView.addGestureRecognizer(tapGesture)
        appleLoginStackView.isUserInteractionEnabled = true
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
    
    @objc private func appleLoginStackViewTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {}
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityTokenData = credential.identityToken,
           let authorizationCodeData = credential.authorizationCode,
           let identityToken = String(data: identityTokenData, encoding: .utf8),
           let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
            
            var name: String = "익명"
            
            if let familyName = credential.fullName?.familyName, let givenName = credential.fullName?.givenName {
                name = "\(familyName) \(givenName)"
            }
            
            loginViewModel.inputs.appleLogin(authCode: authorizationCode, handler: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
