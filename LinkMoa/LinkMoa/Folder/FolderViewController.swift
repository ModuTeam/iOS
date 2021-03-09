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
    private var folders: [FolderList.Result] = []
    
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
        folderCollectionView.register(UINib(nibName: FolderCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FolderCell.cellIdentifier)
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
        guard let addFolderVC = AddFolderViewController.storyboardInstance() else { fatalError() }
        
        addFolderVC.modalPresentationStyle = .fullScreen
        addFolderVC.editCompletionHandler = { [weak self] in
            guard let self = self else { return }
            self.folderViewModel.inputs.fetchFolders()
        }
        addFolderVC.alertSucceedViewHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.fadeInBackgroundViewAnimation()
            self.alertSucceedView { self.blurVC?.fadeOutBackgroundViewAnimation() }
        }
        
        present(addFolderVC, animated: true, completion: nil)
    }
    
    private func presentAddLink() { // 링크 추가 페이지 - 플로팅 버튼
        guard let addLinkVC = AddLinkViewController.storyboardInstance() else { return }

        addLinkVC.alertSucceedViewHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.fadeInBackgroundViewAnimation()
            self.alertSucceedView { self.blurVC?.fadeOutBackgroundViewAnimation() }
        }
        
        let selectNC = SelectNaviagitonController()
        selectNC.pushViewController(addLinkVC, animated: false)
        selectNC.modalPresentationStyle = .fullScreen
        selectNC.isNavigationBarHidden = true
        
        present(selectNC, animated: true, completion: nil)
    }
    
    @objc private func headerSortButtonTapped() {
        guard let _ = homeNavigationController?.topViewController as? HomeViewController else { return }
        guard let editVC = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.modalTransitionStyle = .coverVertical
        
        editVC.editTitle = "정렬하기"
        editVC.actions = ["이름 순", "생성 순"]
        editVC.handlers = [{ [weak self] _ in
            guard let self = self else { return }
            self.folderViewModel.inputs.setFetchOption(option: .name)
            self.folderViewModel.fetchFolders()
        }, { [weak self] _ in
            guard let self = self else { return }
            self.folderViewModel.inputs.setFetchOption(option: .date)
            self.folderViewModel.fetchFolders()
        }]
        editVC.completionHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.fadeOutBackgroundViewAnimation()
        }
   
        blurVC?.fadeInBackgroundViewAnimation()
        present(editVC, animated: true)
    }
    
    @objc private func addButtonTapped() { // 플로팅 버튼 클릭됬을 떄
        guard let _ = homeNavigationController?.topViewController as? HomeViewController else { return }
        guard let editVC = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        
        editVC.editTitle = "추가하기"
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.modalTransitionStyle = .coverVertical
        
        editVC.actions = ["폴더 추가", "링크 추가"]
        editVC.handlers = [{ _ in
            self.presentAddFolder()
        }, { _ in
            self.presentAddLink()
        }]
        editVC.completionHandler = { [weak self] in
            guard let self = self else { return }
            self.blurVC?.fadeOutBackgroundViewAnimation()
        }
        
        blurVC?.fadeInBackgroundViewAnimation()
        present(editVC, animated: true)
    }
    
    @objc private func cellEditButtonTapped(_ sender: UIGestureRecognizer) { // edit 버튼 클릭됬을 때
        guard let button = sender.view as? UICustomTagButton else { return }
        //guard let folder = folders.filter({ $0.index == button.customTag }).first,
        // let index = folders.firstIndex(of: folder) else { return }
        
        guard let editVC = EditBottomSheetViewController.storyboardInstance() else { fatalError() }
        
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.modalTransitionStyle = .coverVertical
        editVC.isIncludeRemoveButton = true
        
        editVC.actions = ["폴더 수정", "URL 공유하기", "삭제하기"] // "URL 공유하기"
        editVC.handlers = [{ [weak self] _ in // 폴더 수정 클릭
            guard let self = self else { return }
            guard let editFolderVC = AddFolderViewController.storyboardInstance() else { return }
            
            editFolderVC.folderPresentingType = .edit
            // editFolderVC.folder = folder
            editFolderVC.modalPresentationStyle = .fullScreen
            
            editFolderVC.alertSucceedViewHandler = {
                self.blurVC?.fadeInBackgroundViewAnimation()
                self.alertSucceedView(completeHandler: { self.blurVC?.fadeOutBackgroundViewAnimation() })
            }
            self.present(editFolderVC, animated: true, completion: nil)
        
        }, { [weak self] _ in
            guard let self = self else { return }
            
            // let shareItem = folder.shareItem
            // let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
//            activityController.excludedActivityTypes = [.saveToCameraRoll, .print, .assignToContact, .addToReadingList]
//
//            self.present(activityController, animated: true, completion: nil)
            
        },{ [weak self] _ in // 삭제하기 클릭
            guard let self = self else { return }
            self.blurVC?.fadeInBackgroundViewAnimation()
//            self.alertRemoveRequestView(folder: folder,
//                                        completeHandler: {
//                                            self.blurVC?.fadeOutBackgroundViewAnimation()
//                                        },
//                                        removeHandler: {
//                                            self.blurVC?.fadeInBackgroundViewAnimation()
//                                            self.alertRemoveSucceedView(completeHandler: { self.blurVC?.fadeOutBackgroundViewAnimation() })
//                                            let indexPath = IndexPath(item: index, section: 0)
//                                            self.folders.remove(at: index)
//                                            self.folderCollectionView.deleteItems(at: [indexPath])
//                                            self.folderCollectionView.collectionViewLayout.invalidateLayout()
//                                            self.folderViewModel.inputs.remove(target: folder)
//                                        })
        }]
        
        editVC.completionHandler = { [weak self] in // 동작 완료하면
            guard let self = self else { return }
            self.blurVC?.fadeOutBackgroundViewAnimation()
        }
        
        blurVC?.fadeInBackgroundViewAnimation()
        present(editVC, animated: true)
    }
}

extension FolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellEditButtonTapped(_:)))
        let folder = folders[indexPath.item]
        
        folderCell.update(by: folder)
        // folderCell.editButton.addGestureRecognizer(tapGesture)
        // folderCell.editButton.customTag = folder.id
        
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
        guard let folderDetailVC = FolderDetailViewController.storyboardInstance() else { fatalError() }
        
        let folder = folders[indexPath.item]
        // folderDetailVC.folder = folder
        folderDetailVC.homeNavigationController = homeNavigationController
        
        folderDetailVC.folderRemoveHandler = { [weak self] in
            guard let self = self else { return }
            
            self.blurVC?.fadeInBackgroundViewAnimation()
            self.alertRemoveSucceedView(completeHandler: { self.blurVC?.fadeOutBackgroundViewAnimation() })
        }
            
        homeNavigationController?.pushViewController(folderDetailVC, animated: true)
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
