//
//  LinkViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/01/31.
//

import UIKit

final class FolderViewController: UIViewController, CustomAlert {

    @IBOutlet private weak var folderCollectionView: UICollectionView!
    @IBOutlet private weak var notificationStackView: UIStackView!
    
    private let folderViewModel: FolderViewModel = FolderViewModel()
    private var folders: [Folder] = []
    
    private var folderHeaderView: FolderHeaderView?
    private var blurVC: BackgroundBlur? {
        return navigationController as? BackgroundBlur
    }
    weak var homeNavigationController: HomeNavigationController?
    
    static func storyboardInstance() -> FolderViewController? {
        let storyboard = UIStoryboard(name: FolderViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFolderCollectionView()
        prepareAddButtonGesture()
        
        bind()
        folderViewModel.inputs.fetchFolders()
    }
    
    private func bind() {
        folderViewModel.outputs.folders.bind { [weak self] results in
            guard let self = self else { return }
            
            self.folders = results
            self.notificationStackView.isHidden = results.count == 0 ? false : true
            self.folderHeaderView?.update(by: results.count)
            self.folderCollectionView.reloadData()
        }
    }

    private func prepareFolderCollectionView() {
        folderCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(UINib(nibName: BookmarkFolderCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: BookmarkFolderCell.cellIdentifier)
        folderCollectionView.register(UINib(nibName: FolderHeaderView.reuseableViewIndetifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FolderHeaderView.reuseableViewIndetifier)
    
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
    }
    
    private func prepareAddButtonGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonTapped))
        tapGesture.delegate = self
        homeNavigationController?.addButtonView.addGestureRecognizer(tapGesture)
    }
    
    private func presentAddFolder() { // 폴더 추가 페이지 - 플로팅 버튼
        guard let addFolderVc = AddFolderViewController.storyboardInstance() else { fatalError() }
        
        addFolderVc.modalPresentationStyle = .fullScreen
        addFolderVc.alertSucceedViewHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.startBackgroundView()
            self.alertSucceedView { self.blurVC?.stopBackgroundView() }
        }
        
        present(addFolderVc, animated: true, completion: nil)
    }
    
    private func presentAddLink() { // 링크 추가 페이지 - 플로팅 버튼
        guard let addLinkVc = AddLinkViewController.storyboardInstance() else { return }

        addLinkVc.alertSucceedViewHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.startBackgroundView()
            self.alertSucceedView { self.blurVC?.stopBackgroundView() }
        }
        
        let navVc = SelectNaviagitonViewController()
        navVc.pushViewController(addLinkVc, animated: false)
        navVc.modalPresentationStyle = .fullScreen
        navVc.isNavigationBarHidden = true
        
        present(navVc, animated: true, completion: nil)
    }
    
    @objc private func headerSortButtonTapped() {
        guard let _ = homeNavigationController?.topViewController as? HomeViewController else { return }
        guard let editVc = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        
        editVc.modalPresentationStyle = .overCurrentContext
        editVc.modalTransitionStyle = .coverVertical
        
        editVc.editTitle = "정렬하기"
        editVc.actions = ["이름 순", "생성 순"]
        editVc.handlers = [{ [weak self] _ in
            guard let self = self else { return }
            self.folderViewModel.inputs.setFetchOption(option: .name)
            self.folderViewModel.fetchFolders()
        }, { [weak self] _ in
            guard let self = self else { return }
            self.folderViewModel.inputs.setFetchOption(option: .date)
            self.folderViewModel.fetchFolders()
        }]
        editVc.completionHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.stopBackgroundView()
        }
   
        blurVC?.startBackgroundView()
        present(editVc, animated: true)
    }
    
    @objc private func addButtonTapped() { // 플로팅 버튼 클릭됬을 떄
        guard let _ = homeNavigationController?.topViewController as? HomeViewController else { return }
        guard let editVc = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        
        editVc.editTitle = "추가하기"
        editVc.modalPresentationStyle = .overCurrentContext
        editVc.modalTransitionStyle = .coverVertical
        
        editVc.actions = ["폴더 추가", "링크 추가"]
        editVc.handlers = [{ _ in
            self.presentAddFolder()
        }, { _ in
            self.presentAddLink()
        }]
        editVc.completionHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.stopBackgroundView()
        }
        
        blurVC?.startBackgroundView()
        present(editVc, animated: true)
    }
    
    @objc private func cellEditButtonTapped(_ sender: UIGestureRecognizer) { // edit 버튼 클릭됬을 때
        guard let button = sender.view as? UICustomTagButton else { return }
        guard let folder = folders.filter({ $0.id == button.customTag }).first,
              let index = folders.firstIndex(of: folder) else { return }
                
        guard let editVc = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        
        editVc.modalPresentationStyle = .overCurrentContext
        editVc.modalTransitionStyle = .coverVertical
        editVc.isIncludeRemoveButton = true
        
        editVc.actions = ["폴더 수정", "URL 공유하기", "삭제하기"] // "URL 공유하기"
        editVc.handlers = [{ [weak self] _ in // 폴더 수정 클릭
            guard let self = self else { return }
            guard let editFolderVc = AddFolderViewController.storyboardInstance() else { return }
            
            editFolderVc.folderPresentingType = .edit
            editFolderVc.folder = folder
            editFolderVc.modalPresentationStyle = .fullScreen
            
            editFolderVc.alertSucceedViewHandler = {
                self.blurVC?.startBackgroundView()
                self.alertSucceedView(completeHandler: { self.blurVC?.stopBackgroundView() })
            }
            self.present(editFolderVc, animated: true, completion: nil)
        
        }, { [weak self] _ in
            guard let self = self else { return }
            
            let shareItem = folder.shareItem
            let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
            activityController.excludedActivityTypes = [.saveToCameraRoll, .print, .assignToContact, .addToReadingList]
            
            self.present(activityController, animated: true, completion: nil)
            
        },{ [weak self] _ in // 삭제하기 클릭
            guard let self = self else { return }
            self.blurVC?.startBackgroundView()
            self.alertRemoveRequestView(folder: folder,
                                        completeHandler: {
                                            self.blurVC?.stopBackgroundView()
                                        },
                                        removeHandler: {
                                            self.blurVC?.startBackgroundView()
                                            self.alertRemoveSucceedView(completeHandler: { self.blurVC?.stopBackgroundView() })
                                            let indexPath = IndexPath(item: index, section: 0)
                                            self.folders.remove(at: index)
                                            self.folderCollectionView.deleteItems(at: [indexPath])
                                            self.folderCollectionView.collectionViewLayout.invalidateLayout()
                                            self.folderViewModel.inputs.remove(target: folder)
                                        })
        }]
        
        editVc.completionHandler = { [weak self] in // 동작 완료하면
            guard let self = self else { return }
            self.blurVC?.stopBackgroundView()
        }
        
        blurVC?.startBackgroundView()
        present(editVc, animated: true)
    }
}

extension FolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkFolderCell.cellIdentifier, for: indexPath) as? BookmarkFolderCell else { fatalError() }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellEditButtonTapped(_:)))
        let folder = folders[indexPath.item]
        
        folderCell.update(by: folder)
        folderCell.editButton.addGestureRecognizer(tapGesture)
        folderCell.editButton.customTag = folder.id
        
        return folderCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FolderHeaderView.reuseableViewIndetifier, for: indexPath) as? FolderHeaderView else { fatalError() }
            
            folderHeaderView = headerView
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerSortButtonTapped))
            
            headerView.sortButton.addGestureRecognizer(tapGesture)
            headerView.sortButton.isUserInteractionEnabled = true
            
            headerView.update(by: folders.count)
            return headerView
        default:
            fatalError()
            break
        }
    }
}

extension FolderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let folderDetailVc = FolderDetailViewController.storyboardInstance() else { fatalError() }
        
        let folder = folders[indexPath.item]
        folderDetailVc.folder = folder
        folderDetailVc.homeNavigationController = homeNavigationController
        
        folderDetailVc.folderRemoveHandler = { [weak self] in
            guard let self = self else { return }
            
            self.blurVC?.startBackgroundView()
            self.alertRemoveSucceedView(completeHandler: { self.blurVC?.stopBackgroundView() })
        }
            
        homeNavigationController?.pushViewController(folderDetailVc, animated: true)
    }
}

extension FolderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 214
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = view.frame.width
        let height: CGFloat = 50
        
        return CGSize(width: width, height: height)
    }
}

extension FolderViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
