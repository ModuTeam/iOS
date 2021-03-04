//
//  RemoveRequestBottomViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/20.
//

import UIKit
import Toast_Swift

final class RemoveRequestBottomViewController: UIViewController {

    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var backGroundView: UIView!
    @IBOutlet private weak var folderNameTextField: UITextField!
    @IBOutlet private weak var deleteButtonView: UIView!
    @IBOutlet private weak var bottomSpacingLayout: NSLayoutConstraint!
    
    var folder: Folder?
    var completionHandler: (() -> ())?
    var removeHandler: (() -> ())?
    
    static func storyboardInstance() -> RemoveRequestBottomViewController? {
        let storyboard = UIStoryboard(name: RemoveRequestBottomViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        prepareBackGroundView()
        prepareBottomViewGesture()
        prepareDeleteButtonView()
        prepareFolderNameTextField()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareBottomViewRoundConer()
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    private func prepareFolderNameTextField() {
        
        folderNameTextField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: folderNameTextField.frame.height))
        folderNameTextField.leftView = paddingView
        folderNameTextField.leftViewMode = .always

        folderNameTextField.layer.masksToBounds = true
        folderNameTextField.layer.cornerRadius = 8
        
        if let folder = folder {
            folderNameTextField.attributedPlaceholder = NSAttributedString(string: folder.name, attributes: [
                .foregroundColor: UIColor.linkMoaPlaceholderColor,
                .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
            ])
        }
    }
    
    private func prepareDeleteButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonViewTapped))
        deleteButtonView.addGestureRecognizer(tapGesture)
        deleteButtonView.isUserInteractionEnabled = true
        
        deleteButtonView.layer.masksToBounds = true
        deleteButtonView.layer.cornerRadius = 8
        deleteButtonView.layer.borderWidth = 1
        deleteButtonView.layer.borderColor = UIColor.linkMoaRedColor.cgColor
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
        backGroundView.addGestureRecognizer(tapGesture)
        backGroundView.isUserInteractionEnabled = true
    }
    
    @objc private func deleteButtonViewTapped() {
        guard let folder = folder, let text = folderNameTextField.text else { return }
        
        if folder.name != text {
            view.makeToast("올바른 폴더 이름을 입력해주세요.", position: .top)
            return
        } else {
            self.completionHandler?()
            
            dismiss(animated: true, completion: {
                self.removeHandler?()
            })
        }
    }
    
    @objc private func backgroundViewTapped() {
        completionHandler?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func bottomViewTapped() {
        folderNameTextField.resignFirstResponder()
    }
        
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomSpacingLayout.constant = keyboardHeight
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSpacingLayout.constant = 0
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func dismissButtonTapped() {
        completionHandler?()
        dismiss(animated: true, completion: nil)
    }
}

extension RemoveRequestBottomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
