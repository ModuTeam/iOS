//
//  SavedFolderViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import UIKit
enum SurfingFolderType {
    case topTen
    case liked
}

class SurfingFolderViewController: UIViewController {
    
    @IBOutlet private weak var folderCollectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    var surfingFolerType: SurfingFolderType = .topTen
    weak var homeNavigationController: HomeNavigationController?
    
    private let viewModel: SurfingFolderViewModel = SurfingFolderViewModel()
    
    var topTenFolders: Observable<[TopTenFolder.Result]> = Observable([])
    var likedFolders: Observable<[LikedFolder.Result]> = Observable([])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFolderCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareNavigationBar()
        prepareNavigationItem()
        prepareHeader()
        bind()
    }
    
    func bind() {
        switch surfingFolerType {
        case .topTen:
            viewModel.inputs.fetchTopTenFolder()
            viewModel.outputs.topTenFolders.bind { [weak self] results in
                guard let self = self else { return }
                self.topTenFolders.value = results
                self.folderCollectionView.reloadData()
            }
        case .liked :
            viewModel.inputs.fetchLikedFolders(word: nil, page: 0)
            viewModel.outputs.likedFolders.bind { [weak self] results in
                guard let self = self else { return }
                self.likedFolders.value = results
                self.countLabel.text = "\(results.map{$0.folderLinkCount}.reduce(0, +).toAbbreviationString)개"
                self.folderCollectionView.reloadData()
            }
        }
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
    
    private func prepareHeader() {
        switch surfingFolerType {
        case .topTen:
            titleLabel.text = "TOP 10 가리비"
            countLabel.isHidden = true
        case .liked:
            titleLabel.text = "찜한 가리비"
        }
        
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
        folderCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 50, right: 16)
        let nib: UINib = UINib(nibName: FolderCell.cellIdentifier, bundle: nil)
        folderCollectionView.register(nib, forCellWithReuseIdentifier: FolderCell.cellIdentifier)
        
        
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
    }
    
    
}


extension SurfingFolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch surfingFolerType {
        case .topTen:
            return topTenFolders.value.count
            
        case .liked :
            return likedFolders.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
        
        switch surfingFolerType {
        case .topTen:
            folderCell.update(by: topTenFolders.value[indexPath.row])
        case .liked :
            folderCell.update(by: likedFolders.value[indexPath.row])
        }
        return folderCell
    }
    
}

extension SurfingFolderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let folderDetailVC = SurfingFolderDetailViewController.storyboardInstance() else { fatalError() }
        folderDetailVC.homeNavigationController = homeNavigationController
        switch surfingFolerType {
        case .topTen:
            folderDetailVC.folderIndex = topTenFolders.value[indexPath.row].folderIndex   
        case .liked :
            folderDetailVC.folderIndex = likedFolders.value[indexPath.row].folderIndex
        }
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
