//
//  CategoryDetailViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import UIKit

class CategoryDetailViewController: UIViewController {


    @IBOutlet private weak var folderCollectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var categoryImageView: UIImageView!

    
    weak var homeNavigationController: HomeNavigationController?
    private let viewModel: CategoryViewModel = CategoryViewModel()
    private var categoryFolders: Observable<[CategoryFolder.FolderList]> = Observable([])
    
    private let categoryMain: [String] = ["개발", "디자인", "마케팅/광고", "기획", "기타"]
    private let categorySub: [String] = ["개발과 관련된 가리비 모음", "디자인과 관련된 가리비 모음", "마케팅/광고와 관련된 가리비 모음", "기획과 관련된 가리비 모음", "기타 가리비 모음"]
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
        bind()
    }
    
    static func storyboardInstance() -> CategoryDetailViewController? {
        let storyboard = UIStoryboard(name: CategoryDetailViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }

    private func bind() {
        viewModel.inputs.fetchCategoryFolder(index: index+1, page: 0)
        viewModel.outputs.categoryFolders.bind { [weak self] results in
            guard let self = self else { return }
            let folders = results.filter {$0.type == .publicFolder}
            self.categoryFolders.value = folders
            self.countLabel.text = "\(folders.count)개"
            self.folderCollectionView.reloadData()
        }
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
        return categoryFolders.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
        folderCell.update(by: categoryFolders.value[indexPath.item])
    
        return folderCell
    }
    
}

extension CategoryDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let folderDetailVC = SurfingFolderDetailViewController.storyboardInstance() else { fatalError() }
        folderDetailVC.homeNavigationController = homeNavigationController
        folderDetailVC.folderIndex = categoryFolders.value[indexPath.item].index
        
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
