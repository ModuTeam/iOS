//
//  AddLinkViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/17.
//

import UIKit
import Toast_Swift

enum EditPresetingStyle {
    case add
    case edit
}

final class AddLinkViewController: UIViewController {
    
    @IBOutlet private weak var linkTitleTextField: UITextField! // tag 1
    @IBOutlet private weak var linkURLTextField: UITextField! // tag 2
    @IBOutlet private weak var folderSelectionView: UIView!
    @IBOutlet private weak var folderPlaceHolderLabel: UILabel!
    @IBOutlet private weak var folderSelectionLabel: UILabel!
    @IBOutlet private weak var saveButtonView: UIView!
    
    private let linkViewModel = LinkViewModel()
    private let folderViewModel = FolderViewModel()
    private let linkPresentaionService = LinkPresentaionService()
    
    public var isLinkUpdated: Bool = false
    var linkPresetingStyle: EditPresetingStyle = .add
    
    var link: Link? // for edit
    
    private var destinationFolder: Folder?
    var folder: Folder?
    var updateReloadHander: (() -> ())?
    var alertSucceedViewHandler: (() -> ())? // test
    
    private var isButtonClicked: Bool = false
    
    static func storyboardInstance() -> AddLinkViewController? {
        let storyboard = UIStoryboard(name: AddLinkViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationFolder = folder
        update()
        prepareFolderSelectionView() // 메인에서 클릭했을 떄에만
        prepareViewGesture()
        prepareSaveButtonView()
        prepareLinkTitleTextField()
        prepareLinkURLTextField()
    }
    
    private func update() {
        guard let destinationFolder = destinationFolder else { return }
        
        folderSelectionLabel.text = destinationFolder.name
        folderSelectionLabel.isHidden = false
        folderPlaceHolderLabel.isHidden = true
        
        switch linkPresetingStyle {
        case .edit:
            guard let link = link, !isLinkUpdated else { return }
            
            linkTitleTextField.text = link.name
            linkURLTextField.text = link.url
            isLinkUpdated.toggle()
        default:
            break
        }
    }
    
    private func prepareFolderSelectionView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(folderSelectionViewTapped))
        folderSelectionView.addGestureRecognizer(tapGesture)
        folderSelectionView.isUserInteractionEnabled = true
        
        folderSelectionView.layer.masksToBounds = true
        folderSelectionView.layer.cornerRadius = 8
        folderSelectionView.layer.borderColor = UIColor.linkMoaFolderSeletionBorderColor.cgColor
        folderSelectionView.layer.borderWidth = 1
    }
    
    private func prepareSaveButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped))
        saveButtonView.addGestureRecognizer(tapGesture)
        saveButtonView.isUserInteractionEnabled = true
        
        saveButtonView.layer.masksToBounds = true
        saveButtonView.layer.cornerRadius = 8
    }
    
    private func prepareLinkTitleTextField() {
        linkTitleTextField.delegate = self
        linkTitleTextField.tag = 1
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: linkTitleTextField.frame.height))
        linkTitleTextField.leftView = paddingView
        linkTitleTextField.leftViewMode = .always
        
        linkTitleTextField.attributedPlaceholder = NSAttributedString(string: "네이버", attributes: [
            .foregroundColor: UIColor.placeholderText,
            .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        
        linkTitleTextField.layer.masksToBounds = true
        linkTitleTextField.layer.cornerRadius = 8
    }
    
    private func prepareLinkURLTextField() {
        linkURLTextField.delegate = self
        linkURLTextField.tag = 2
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: linkURLTextField.frame.height))
        linkURLTextField.leftView = paddingView
        linkURLTextField.leftViewMode = .always
        
        linkURLTextField.attributedPlaceholder = NSAttributedString(string: "https://www.naver.com", attributes: [
            .foregroundColor: UIColor.placeholderText,
            .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        
        linkURLTextField.layer.masksToBounds = true
        linkURLTextField.layer.cornerRadius = 8
    }
    
    private func prepareViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
    }
    
    @objc private func folderSelectionViewTapped() {
        guard let folderSelectVC = FolderSelectViewController.storyboardInstance() else { return }
        
        folderSelectVC.selectHandler = { [weak self] folder in
            guard let self = self else { return }
            self.destinationFolder = folder
            self.update()
        }
        navigationController?.pushViewController(folderSelectVC, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard !isButtonClicked else { return }
        
        guard let name = linkTitleTextField.text, !name.isEmpty else {
            view.makeToast("링크 이름을 입력해주세요.", position: .top)
            return
        }
        
        guard let url = linkURLTextField.text, !url.isEmpty else {
            view.makeToast("링크 주소를 입력해주세요.", position: .top)
            return
        }
        
        guard url.isValidHttps() else {
            view.makeToast("올바른 링크 주소를 입력해주세요.", position: .top)
            return
        }
        
        guard let destinationFolder = destinationFolder else {
            view.makeToast("저장할 폴더를 선택해주세요.", position: .top)
            return
        }
        
        switch linkPresetingStyle {
        case .add:
            isButtonClicked.toggle()
            
            view.makeToastActivity(ToastPosition.center)
            linkPresentaionService.fetchLinkMetaData(urlString: url, completionHandler: { [weak self] web, favicon in
                guard let self = self else { return }
                
                let addLink = Link(name: name, url: url, webPreview: web?.pngData() ?? nil, favicon: favicon?.pngData() ?? nil)
                
                DispatchQueue.main.async {
//                    self.folderViewModel.update {
//                        destinationFolder.links.append(addLink)
//                    }
                    
                    self.view.hideAllToasts()
                    self.dismiss(animated: true, completion: {
                        self.alertSucceedViewHandler?()
                    })
                }
            })
            
        case .edit:
            guard let folder = folder, let link = link else { return }
            
            if folder.id != destinationFolder.id { // move
                
                if link.url != url { // move & edit url
                    isButtonClicked.toggle()
                    
                    view.makeToastActivity(ToastPosition.center)
                    linkPresentaionService.fetchLinkMetaData(urlString: url, completionHandler: { [weak self] web, favicon in
                        guard let self = self else { return }
                        
                        let addLink = Link(name: name, url: url, webPreview: web?.pngData() ?? nil, favicon: favicon?.pngData() ?? nil)
                        
                        DispatchQueue.main.async {
//                            self.folderViewModel.remove(target: link)
//                            self.folderViewModel.update {
//                                destinationFolder.links.append(addLink)
//                            }
                            
                            self.view.hideAllToasts()
                            self.dismiss(animated: true, completion: {
                                self.alertSucceedViewHandler?()
                            })
                        }
                    })
                } else { // default move
                    let addLink = Link(name: link.name, url: link.url, webPreview: link.webPreview, favicon: link.favicon)
                    
//                    folderViewModel.remove(target: link)
//                    folderViewModel.update {
//                        destinationFolder.links.append(addLink)
//                    }
                    
                    dismiss(animated: true, completion: {
                        self.alertSucceedViewHandler?()
                    })
                    
                    return
                }
            } else { // update
                if link.url != url { // update & edit url
                    isButtonClicked.toggle()
                    
                    view.makeToastActivity(ToastPosition.center)
                    linkPresentaionService.fetchLinkMetaData(urlString: url, completionHandler: { [weak self] web, favicon in
                        guard let self = self else { return }
                        
                        DispatchQueue.main.async {
//                            self.folderViewModel.update {
//                                link.name = name
//                                link.url = url
//                                link.webPreview = web?.pngData()
//                                link.favicon = favicon?.pngData()
//                            }
                            
                            self.view.hideAllToasts()
                            self.updateReloadHander?() // use only update
                            self.dismiss(animated: true, completion: {
                                self.alertSucceedViewHandler?()
                            })
                        }
                    })
                } else { // default update
//                    folderViewModel.update {
//                        link.name = name
//                        link.url = url
//                    }
                    
                    self.updateReloadHander?() // use only update
                    dismiss(animated: true, completion: {
                        self.alertSucceedViewHandler?()
                    })
                    
                    return
                }
            }
        }
    }
    
    @IBAction func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddLinkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            textField.resignFirstResponder()
            linkURLTextField.becomeFirstResponder()
        case 2:
            textField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
}
