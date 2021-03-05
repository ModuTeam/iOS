//
//  ShareViewController.swift
//  LinkMoaShareExtension
//
//  Created by won heo on 2021/02/10.
//

import UIKit
import Social
import MobileCoreServices
import Toast_Swift

class ShareViewController: UIViewController, CustomAlert {

    @IBOutlet private weak var linkTitleTextField: UITextField! // tag 1
    @IBOutlet private weak var linkURLTextField: UITextField! // tag 2
    @IBOutlet private weak var folderSelectionView: UIView!
    @IBOutlet private weak var folderPlaceHolderLabel: UILabel!
    @IBOutlet private weak var folderSelectionLabel: UILabel!
    @IBOutlet private weak var saveButtonView: UIView!

    private let linkPresentaionService = LinkPresentaionService()
    private let shareViewModel = ShareViewModel()
    
    private var blurVC: BackgroundBlur? {
        return navigationController as? BackgroundBlur
    }
    
    private var urlString: String = "" {
        didSet {
            self.linkURLTextField.text = urlString
            
            linkPresentaionService.fetchTitle(urlString: urlString, completionHandler: { title in
                DispatchQueue.main.async {
                    self.linkTitleTextField.text = title
                }
            })
        }
    }
    
    private var isButtonClicked: Bool = false
    private var destinationFolder: Folder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchShareURL()
        prepareFolderSelectionView()
        prepareSaveButtonView()
        prepareLinkTitleTextField()
        prepareLinkURLTextField()
        prepareViewGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func fetchShareURL() {
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first {
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                            DispatchQueue.main.async {
                                self.urlString = shareURL.absoluteString ?? ""
                            }
                        }
                    })
                }
            }
        }
    }
    
    private func update() {
        guard let destinationFolder = destinationFolder else { return }
        
        folderSelectionLabel.text = destinationFolder.name
        folderSelectionLabel.isHidden = false
        folderPlaceHolderLabel.isHidden = true
    }
    
    private func prepareViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    private func prepareFolderSelectionView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(folderSelectionViewTapped))
        folderSelectionView.addGestureRecognizer(tapGesture)
        folderSelectionView.isUserInteractionEnabled = true
        
        folderSelectionView.layer.masksToBounds = true
        folderSelectionView.layer.cornerRadius = 8
        folderSelectionView.layer.borderColor = UIColor(rgb: 0xbcbdbe).cgColor
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
        // linkTitleTextField.delegate = self
        linkTitleTextField.tag = 1
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: linkTitleTextField.frame.height))
        linkTitleTextField.leftView = paddingView
        linkTitleTextField.leftViewMode = .always
        
        linkTitleTextField.attributedPlaceholder = NSAttributedString(string: "네이버", attributes: [
            .foregroundColor: UIColor(rgb: 0xbdbdbd),
            .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        
        linkTitleTextField.layer.masksToBounds = true
        linkTitleTextField.layer.cornerRadius = 8
    }
    
    private func prepareLinkURLTextField() {
        // linkURLTextField.delegate = self
        linkURLTextField.tag = 2
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: linkURLTextField.frame.height))
        linkURLTextField.leftView = paddingView
        linkURLTextField.leftViewMode = .always
        
        linkURLTextField.attributedPlaceholder = NSAttributedString(string: "https://www.naver.com", attributes: [
            .foregroundColor: UIColor(rgb: 0xbdbdbd),
            .font: UIFont(name: "NotoSansCJKkr-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        
        linkURLTextField.layer.masksToBounds = true
        linkURLTextField.layer.cornerRadius = 8
    }
    
    func hideExtensionWithCompletionHandler(completionHandler: @escaping () -> ()) {
        UIView.animate(withDuration: 0.20, animations: { () -> Void in
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        }, completion: { _ in
            completionHandler()
        })
    }
    
    @objc private func folderSelectionViewTapped() {
        guard let folderSelectVc = ShareFolderSelectionViewController.storyboardInstance() else { return }

        folderSelectVc.selectHandler = { [weak self] folder in
            guard let self = self else { return }
            self.destinationFolder = folder
            self.update()
        }
        
        navigationController?.pushViewController(folderSelectVc, animated: true)
    }
    
    @objc private func viewTapped() {
        view.endEditing(true)
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
        
        isButtonClicked.toggle()
        view.makeToastActivity(ToastPosition.center)
        
        linkPresentaionService.fetchLinkMetaData(urlString: url, completionHandler: { [weak self] web, favicon in
            guard let self = self else { return }
            
            let addLink = Link(name: name, url: url, webPreview: web?.pngData() ?? nil, favicon: favicon?.pngData() ?? nil)
            
            DispatchQueue.main.async {
                self.shareViewModel.update {
                    destinationFolder.links.append(addLink)
                }
                
                self.view.hideToastActivity()
                
                self.blurVC?.fadeInBackgroundViewAnimation()
                self.alertSucceedView(completeHandler: {
                    self.blurVC?.fadeOutBackgroundViewAnimation()
                    self.hideExtensionWithCompletionHandler(completionHandler: {
                        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                    })
                })
            }
        })
    }
    
    @IBAction func dismissButtonTapped() {
        hideExtensionWithCompletionHandler(completionHandler: {
            self.extensionContext!.cancelRequest(withError: NSError())
        })
    }
}
