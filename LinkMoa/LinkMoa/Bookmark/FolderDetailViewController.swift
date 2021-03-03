//
//  BookMarkDetailViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/07.
//

import UIKit

final class FolderDetailViewController: UIViewController, CustomAlert {

    @IBOutlet private weak var folderTitleLabel: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var linkCountLabel: UILabel!
    @IBOutlet private weak var lockImageView: UIImageView!
    @IBOutlet private weak var subHeaderView: UIView!
    @IBOutlet private(set) weak var linkCollectionView: UICollectionView!
    
    private let linkViewModel: LinkViewModel = LinkViewModel()
    private var links: [Link] = []
    
    weak var homeNavigationController: HomeNavigationController?
    // weak var folderViewController: FolderViewController?
 
    private var blurVC: BackgroundBlur? {
        return navigationController as? BackgroundBlur
    }
    
    var folderRemoveHandler: (() -> ())?
    var folder: Folder?
    
    static func storyboardInstance() -> FolderDetailViewController? {
        let storyboard = UIStoryboard(name: FolderDetailViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let folder = folder {
            linkViewModel.folderSource = folder
        }
        prepareLinkCollectionView()
        prepareAddButtonGesture()
        prepareSubHeaderView()
        prepareNavigationItem()
        prepareNavigationBar()
        
        bind()
        linkViewModel.inputs.attachObserver()
        
        update() // data update by presenting VC
    }
    
    private func bind() {
        linkViewModel.outputs.links.bind { [weak self] links in
            guard let self = self else { return }
            self.links = links
            self.linkCountLabel.text = String(links.count)
            self.linkCollectionView.reloadData()
        }
        
        linkViewModel.outputs.folderName.bind { [weak self] name in
            guard let self = self else { return }
            self.folderTitleLabel.text = name
        }
        
        linkViewModel.outputs.tags.bind { [weak self] tags in
            guard let self = self else { return }
            self.updateTagStackView(tags: tags)
        }
        
        linkViewModel.outputs.isShared.bind { [weak self] isShared in
            guard let self = self else { return }
            self.lockImageView.isHidden = isShared ? true : false
        }
    }
    
    private func update() {
        guard let folder = folder else { return }
        
        lockImageView.isHidden = folder.isShared ? true : false
        folderTitleLabel.text = folder.name
        links = folder.links.map { $0 }
        linkCountLabel.text = String(links.count)
        updateTagStackView(tags: folder.tags.map { $0.name })
    }
    
    private func updateTagStackView(tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }

        for tag in tags {
            let label = UILabel(frame: CGRect.zero)
            label.text = "#" + tag
            label.textColor = UIColor.white
            label.font = UIFont(name: "NotoSansKR-Regular", size: 14)

            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func prepareLinkCollectionView() {
        linkCollectionView.register(UINib(nibName: LinkCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: LinkCell.cellIdentifier)
        linkCollectionView.dataSource = self
        linkCollectionView.delegate = self
    }
    
    private func prepareAddButtonGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonTapped))
        tapGesture.delegate = self
        homeNavigationController?.addButtonView.addGestureRecognizer(tapGesture)
    }
    
    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func prepareNavigationItem() {
        let editBarButtonItem = UIBarButtonItem(image: UIImage(named: "editDot"), style: .plain, target: self, action: #selector(folderEditButtonTapped))
        editBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        editBarButtonItem.tintColor = .white
        
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        searchBarButtonItem.tintColor = .white
        
        navigationItem.rightBarButtonItems = [editBarButtonItem, searchBarButtonItem]
    }
    
    private func prepareSubHeaderView() {
        subHeaderView.layer.masksToBounds = true
        subHeaderView.layer.cornerRadius = 10
    }
    
    @objc private func folderEditButtonTapped() {
        guard let folder = folder else { return }
        
        guard let editVc = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        guard let editFolderVc = AddFolderViewController.storyboardInstance() else { return }
        
        editVc.modalPresentationStyle = .overCurrentContext
        editVc.modalTransitionStyle = .coverVertical
        editVc.isIncludeRemoveButton = true // 마지막 label red

        editVc.completionHandler = { [weak self] in
            self?.blurVC?.stopBackgroundView()
        }
        
        editVc.actions = ["폴더 수정", "URL 공유하기", "삭제하기"]
        editVc.handlers = [{ [weak self] _ in  // 폴더 수정
            guard let self = self else { return }
        
            editFolderVc.modalPresentationStyle = .fullScreen
            editFolderVc.folderPresentingType = .edit
            
            editFolderVc.folder = self.folder
            editFolderVc.alertSucceedViewHandler = { [weak self] in
                guard let self = self else { return }
                self.blurVC?.startBackgroundView()
                self.alertSucceedView { self.blurVC?.stopBackgroundView() }
            }
            
            self.present(editFolderVc, animated: true, completion: nil)
        }, { [weak self] _ in
            guard let self = self else { return }
            
            let shareItem = folder.shareItem
            let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
            activityController.excludedActivityTypes = [.saveToCameraRoll, .print, .assignToContact, .addToReadingList]
            
            self.present(activityController, animated: true, completion: nil)
        }, { [weak self] _ in // 삭제하기
            guard let self = self else { return }
            guard let folder = self.folder else { return }
            
            self.blurVC?.startBackgroundView()
            self.alertRemoveRequestView(folder: folder,
                                        completeHandler: {
                                            self.blurVC?.stopBackgroundView()
                                        },
                                        removeHandler: {
                                            self.linkViewModel.inputs.removeFolder(target: folder)
                                            self.blurVC?.stopBackgroundView()
                                            
                                            self.navigationController?.popToRootViewController(animated: true)
                                            self.folderRemoveHandler?()
                                        })
        }]
        
        // homeNavigationController?.animateBackgroundView()
        blurVC?.startBackgroundView()
        navigationController?.present(editVc, animated: true)
    }
    
    @objc private func addButtonTapped() {
        guard let _ = homeNavigationController?.topViewController as? FolderDetailViewController else { return }
        guard let addLinkVc = AddLinkViewController.storyboardInstance() else { fatalError() }
        
        let navVc = SelectNaviagitonViewController()
        navVc.pushViewController(addLinkVc, animated: false)
        navVc.modalPresentationStyle = .fullScreen
        navVc.isNavigationBarHidden = true
        
        addLinkVc.folder = folder
        addLinkVc.alertSucceedViewHandler = { [weak self] in
            guard let self = self else { return }
            
            self.blurVC?.startBackgroundView()
            self.alertSucceedView(completeHandler: { self.blurVC?.stopBackgroundView() })
        }
        
        present(navVc, animated: true, completion: nil)
    }
    
    @objc private func cellEditButtonTapped(_ sender: UIGestureRecognizer) { // edit 버튼 클릭됬을 때
        guard let button = sender.view as? UICustomTagButton else { return }
        guard let link = links.filter({$0.id == button.customTag}).first else { return }
        guard let index = links.firstIndex(of: link) else { return }
        guard let folder = folder else { return }
        
        guard let editVc = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        
        editVc.modalPresentationStyle = .overCurrentContext
        editVc.modalTransitionStyle = .coverVertical
        editVc.isIncludeRemoveButton = true
        
        editVc.actions = ["링크 수정", "URL 공유하기", "삭제하기"] // "URL 공유하기"
        editVc.handlers = [{ [weak self] _ in // 링크 수정
            guard let self = self else { return }
            
            guard let addLinkVc = AddLinkViewController.storyboardInstance() else { return }
            
            addLinkVc.linkPresetingStyle = .edit
            addLinkVc.link = link
            addLinkVc.folder = folder
            addLinkVc.alertSucceedViewHandler = { [weak self] in
                guard let self = self else { return }
                
                self.blurVC?.startBackgroundView()
                self.alertSucceedView(completeHandler: { self.blurVC?.stopBackgroundView() })
            }
            addLinkVc.updateReloadHander = { [weak self] in
                guard let self = self else { return }
                self.linkCollectionView.reloadData()
            }

            let navVc = SelectNaviagitonViewController()
            navVc.pushViewController(addLinkVc, animated: false)
            navVc.modalPresentationStyle = .fullScreen
            navVc.isNavigationBarHidden = true
            
            self.present(navVc, animated: true, completion: nil)
            
        }, { [weak self] _ in // URL 공유하기
            guard let self = self else { return }
            
            let activityController = UIActivityViewController(activityItems: ["\(link.name)\n\(link.url)"], applicationActivities: nil)
            activityController.excludedActivityTypes = [.saveToCameraRoll, .print, .assignToContact, .addToReadingList]
            self.present(activityController, animated: true, completion: nil)
            
        }, { [weak self] _ in // 삭제하기
            guard let self = self else { return }
            let indexPath = IndexPath(item: index, section: 0)
            
            self.linkViewModel.removeLink(target: link)
            self.links.remove(at: index)
            self.linkCollectionView.deleteItems(at: [indexPath])
            
            self.blurVC?.startBackgroundView()
            self.alertRemoveSucceedView(completeHandler: { self.blurVC?.stopBackgroundView() })
        }]
        
        editVc.completionHandler = { [weak self] in // 동작 완료하면
            // guard let self = self else { return }
            // self.homeNavigationController?.dismissBackGroundView()
            self?.blurVC?.stopBackgroundView()
        }
        
        // homeNavigationController?.animateBackGroundView()
        blurVC?.startBackgroundView()
        present(editVc, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        guard let searchLinkVc = SearchLinkViewController.storyboardInstance() else { return }
        
        searchLinkVc.modalTransitionStyle = .crossDissolve
        searchLinkVc.modalPresentationStyle = .overCurrentContext
        
        searchLinkVc.folder = folder
//        searchLinkVc.removeBackgroundHandler = { [weak self] in
//            // guard let self = self else { return }
//            // self.homeNavigationController?.dismissBackGroundView()
//
//        }
        // searchLinkVc.homeNavigationController = homeNavigationController
        searchLinkVc.folderDetailViewController = self
        homeNavigationController?.present(searchLinkVc, animated: true, completion: nil)
    }
}

extension FolderDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FolderDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let linkCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCell.cellIdentifier, for: indexPath) as? LinkCell else { return UICollectionViewCell() }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellEditButtonTapped(_:)))
        let link = links[indexPath.item]
        
        linkCell.update(by: link)
        linkCell.editButton.addGestureRecognizer(tapGesture)
        linkCell.editButton.customTag = link.id
        
        return linkCell
    }
}

extension FolderDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = links[indexPath.item]
        
        //사파리로 링크열기
        if let url = URL(string: link.url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension FolderDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - (18 * 2)
        let height: CGFloat = 83
        return CGSize(width: width, height: height)
    }
}
