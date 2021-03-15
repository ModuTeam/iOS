//
//  SearchFolderResultViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import UIKit

final class SearchFolderResultViewController: UIViewController {

    @IBOutlet var folderCollectionView: UICollectionView!

    var searchedFolders: Observable<[SearchFolder.Result]> = Observable([])
    var searchTarget: SearchTarget = .my
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFolderCollectionView()
    }
    
    static func storyboardInstance() -> SearchFolderResultViewController? {
        let storyboard = UIStoryboard(name: SearchFolderResultViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    private func prepareFolderCollectionView() {
        folderCollectionView.contentInset = UIEdgeInsets(top: 24, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(UINib(nibName: FolderCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FolderCell.cellIdentifier)
        folderCollectionView.register(UINib(nibName: FolderHeaderView.reuseableViewIndetifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FolderHeaderView.reuseableViewIndetifier)
    
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
    }
}

extension SearchFolderResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedFolders.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
        
        folderCell.update(by: searchedFolders.value[indexPath.row])
        
        DEBUG_LOG(searchTarget)
        return folderCell
    }
}

extension SearchFolderResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DEBUG_LOG(searchTarget)
        switch searchTarget {
        case .my:
            guard let folderDetailVC = FolderDetailViewController.storyboardInstance() else { fatalError() }
            navigationController?.pushViewController(folderDetailVC, animated: true)
        case .surf:
            guard let folderDetailVC = SurfingFolderDetailViewController.storyboardInstance() else { fatalError() }
            
            navigationController?.pushViewController(folderDetailVC, animated: true)
        }   
    }
}

extension SearchFolderResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 214
        
        return CGSize(width: width, height: height)
    }
}
