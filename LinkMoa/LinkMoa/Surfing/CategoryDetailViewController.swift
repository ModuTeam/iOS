//
//  CategoryDetailViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import UIKit

class CategoryDetailViewController: UIViewController {

    @IBOutlet weak var folderCollectionView: UICollectionView!
    weak var homeNavigationController: HomeNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        prepareFolderCollectionView()
    }
    
    static func storyboardInstance() -> CategoryDetailViewController? {
        let storyboard = UIStoryboard(name: CategoryDetailViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
    }

    private func prepareFolderCollectionView() {
        folderCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(UINib(nibName: FolderCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: FolderCell.cellIdentifier)
        folderCollectionView.register(UINib(nibName: FolderHeaderView.reuseableViewIndetifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FolderHeaderView.reuseableViewIndetifier)
    
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
    }
}


extension CategoryDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
        
    
        return folderCell
    }
    
}

extension CategoryDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let folderDetailVC = FolderDetailViewController.storyboardInstance() else { fatalError() }
        
   
        folderDetailVC.homeNavigationController = homeNavigationController
        
      
        homeNavigationController?.pushViewController(folderDetailVC, animated: true)
    }
}

extension CategoryDetailViewController: UICollectionViewDelegateFlowLayout {
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
