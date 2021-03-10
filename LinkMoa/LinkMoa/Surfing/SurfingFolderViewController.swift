//
//  SavedFolderViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import UIKit

class SurfingFolderViewController: UIViewController {
    
    @IBOutlet weak var folderCollectionView: UICollectionView!
    weak var homeNavigationController: HomeNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFolderCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareNavigationBar()
        prepareNavigationItem()
    }
        
    static func storyboardInstance() -> SurfingFolderViewController? {
        let storyboard = UIStoryboard(name: SurfingFolderViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func prepareNavigationItem() {
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "editDot"), style: .plain, target: self, action: #selector(folderShareButtonTapped))
        shareBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        shareBarButtonItem.tintColor = .black
        
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        searchBarButtonItem.tintColor = .black
        
        navigationItem.rightBarButtonItems = [shareBarButtonItem, searchBarButtonItem]
    }

    @objc private func folderShareButtonTapped() {
        
    }
    
    @objc private func searchButtonTapped() {
        guard let searchLinkVC = SearchInFolderViewController.storyboardInstance() else { return }
        
        searchLinkVC.modalTransitionStyle = .crossDissolve
        searchLinkVC.modalPresentationStyle = .overCurrentContext
        
        homeNavigationController?.present(searchLinkVC, animated: true, completion: nil)
    }
    
    private func prepareFolderCollectionView() {
        folderCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 50, right: 15)
        let nib: UINib = UINib(nibName: FolderCell.cellIdentifier, bundle: nil)
        folderCollectionView.register(nib, forCellWithReuseIdentifier: FolderCell.cellIdentifier)
        
        
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
    }
}


extension SurfingFolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
        
        
        return folderCell
    }
    
}

extension SurfingFolderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let folderDetailVC = SurfingFolderDetailViewController.storyboardInstance() else { fatalError() }
        
        
        folderDetailVC.homeNavigationController = homeNavigationController
        
        
        homeNavigationController?.pushViewController(folderDetailVC, animated: true)
    }
}

extension SurfingFolderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 214
        
        return CGSize(width: width, height: height)
    }
   
}
