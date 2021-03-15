//
//  CategoryDetailViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import UIKit

class CategoryDetailViewController: UIViewController {

    @IBOutlet weak var folderCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    weak var homeNavigationController: HomeNavigationController?
    let categoryMain: [String] = ["개발", "디자인", "마케팅/광고", "기획", "기타"]
    let categorySub: [String] = ["개발과 관련된 가리비 모음", "디자인과 관련된 가리비 모음", "마케팅/광고와 관련된 가리비 모음", "기획과 관련된 가리비 모음", "기타 가리비 모음"]
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareNavigationItem()
        prepareFolderCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareNavigationBar()
        updateUI()
    }
    
    static func storyboardInstance() -> CategoryDetailViewController? {
        let storyboard = UIStoryboard(name: CategoryDetailViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    private func prepareNavigationBar() {
//        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func prepareNavigationItem() {
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "editDot"), style: .plain, target: self, action: #selector(folderShareButtonTapped))
        shareBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        shareBarButtonItem.tintColor = .white
        
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        searchBarButtonItem.tintColor = .white
        
        navigationItem.rightBarButtonItems = [shareBarButtonItem, searchBarButtonItem]
    }
    
    private func updateUI() {
        titleLabel.text = categoryMain[index]
        subTitleLabel.text = categorySub[index]
        categoryImageView.contentMode = .scaleAspectFill
        categoryImageView.layer.cornerRadius = 36
        categoryImageView.image = UIImage(named: "category_\(index)")
        countLabel.text = "\(10.toAbbreviationString)개"
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
    

}
