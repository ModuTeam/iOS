//
//  FolderListViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import UIKit

final class FolderListViewController: UIViewController {

    @IBOutlet private var folderCollectionView: UICollectionView!
    
    var folders: [Folder] = [] {
        didSet {
            guard let folderCollectionView = folderCollectionView else { return }
            folderCollectionView.reloadData()
        }
    }
    
    
    static func storyboardInstance() -> FolderListViewController? {
        let storyboard = UIStoryboard(name: FolderListViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFolderCollectionView()
        // Do any additional setup after loading the view.
    }
    
    private func prepareFolderCollectionView() {
        folderCollectionView.contentInset = UIEdgeInsets(top: 24, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(UINib(nibName: BookmarkFolderCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: BookmarkFolderCell.cellIdentifier)
        folderCollectionView.register(UINib(nibName: FolderHeaderView.reuseableViewIndetifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FolderHeaderView.reuseableViewIndetifier)
    
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
    }

}

extension FolderListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkFolderCell.cellIdentifier, for: indexPath) as? BookmarkFolderCell else { fatalError() }
        
//      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellEditButtonTapped(_:)))
        let folder = folders[indexPath.item]
        
        folderCell.update(by: folder)
// folderCell.editButton.addGestureRecognizer(tapGesture)
        folderCell.editButton.customTag = folder.id
        
        return folderCell
    }
}



extension FolderListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let folderDetailVc = FolderDetailViewController.storyboardInstance() else { fatalError() }
        
        let folder = folders[indexPath.item]
        folderDetailVc.folder = folder
        // folderDetailVc.homeNavigationController = homeNavigationController
        // folderDetailVc.folderViewController = self
        folderDetailVc.folderRemovedHandler = { [weak self] in
            guard let self = self else { return }
            // self.alertRemoveSucceedView()
        }
            
        navigationController?.pushViewController(folderDetailVc, animated: true)
    }
}

extension FolderListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 214
        
        return CGSize(width: width, height: height)
    }
}
