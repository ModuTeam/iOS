//
//  SurfingViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/05.
//

import UIKit

final class SurfingViewController: UIViewController {
    
    @IBOutlet weak var surfingCollectionView: UICollectionView!
    
    weak var homeNavigationController: HomeNavigationController?
    
    private let viewModel: SurfingViewModel = SurfingViewModel()
    let surfingManager =  SurfingManager()
    let myScallopManager =  MyScallopManager()
    
    var topTenFolders: Observable<[TopTenFolder.Result]> = Observable([])
    var likedFolders: Observable<[LikedFolder.Result]> = Observable([])
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        test()
        viewModel.inputs.fetchTopTenFolder()
        viewModel.inputs.fetchLikedFolders()
        
        bind()
        
        print("🥺test", 100.toAbbreviationString, 1011.toAbbreviationString, 1100.toAbbreviationString, 10100.toAbbreviationString, 11111.toAbbreviationString, 12345678.toAbbreviationString, 123456789.toAbbreviationString)
    }
    
    static func storyboardInstance() -> SurfingViewController? {
        let storyboard = UIStoryboard(name: SurfingViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func bind() {
        viewModel.outputs.topTenFolders.bind { [weak self] results  in
            guard let self = self else { return }
            print("topTenFolders", results)
            self.topTenFolders.value = results
            self.surfingCollectionView.reloadData()
        }
        
        viewModel.outputs.likedFolders.bind { [weak self] results  in
            guard let self = self else { return }
            print("likedFolders", results)
            self.likedFolders.value = results
            self.surfingCollectionView.reloadData()
        }
    }
    
    func test() {
        
        //MARK:- 폴더상세조회
        //        surfingManager.fetchFolderDetail(folder: 2) { result in
        //            print("🥺test", result)
        //        }
        
        //MARK:- 저장한가리비폴더조회
        //        surfingManager.fetchLikedFolder { result in
        //            print("🥺test", result)
        //        }
        
        //MARK:- 폴더리스트조회
        //        myScallopManager.fetchMyFolderList(user: 1) { result in
        //            print("🥺test", result)
        //        }
        //
        //MARK:- 폴더생성
        //        let params: [String: Any] = ["folderName": "test",
        //                                     "hashTagList": ["test1","test2"],
        //                                     "categoryIdx": 1,
        //                                     "folderType": "private"
        //        ]
        //
        //        myScallopManager.addNewFolder(params: params) { result in
        //            print("🥺test", result)
        //        }
        
        //MARK:- 폴더수정
        //        let params: [String: Any] = ["folderName": "edit",
        //                                     "hashTagList": ["edit1","edit2"],
        //                                     "categoryIdx": 1,
        //                                     "folderType": "private"
        //        ]
        //
        //        myScallopManager.editFolder(folder: 8, params: params) { result in
        //            print("🥺test", result)
        //        }
        //MARK:- 폴더삭제
        //        myScallopManager.deleteFolder(folder: 9) { result in
        //            print("🥺test", result)
        //        }
        
        //MARK:- 링크추가
        //        let params: [String: Any] = ["linkName": "testLInk",
        //                                     "linkUrl": "https://velopert.com/2389"
        //        ]
        //
        //        myScallopManager.addLink(folder: 8, params: params) { result in
        //            print("🥺test", result)
        //        }
        //MARK:- 링크수정
//        let params: [String: Any] = ["folderIdx": 8,
//                                     "linkName": "editTestLInk",
//                                     "linkUrl": "https://velopert.com/2389"
//        ]
//
//        myScallopManager.editLink(link: 1, params: params) { result in
//            print("🥺test", result)
//        }
        //MARK:- 링크수정
//        myScallopManager.deleteLInk(link: 1) { result in
//            print("🥺test", result)
//        }
        //MARK:- topten
//        surfingManager.fetchTopTenFolder { result in
//            print("🥺test", result)
//        }
        
        
    }
    
    private func prepareCollectionView() {
        surfingCollectionView.collectionViewLayout = createSectionLayout()
        
        let nib1 = UINib(nibName: FolderCell.cellIdentifier, bundle: nil)
        let nib2 = UINib(nibName: SurfingCategoryCell.cellIdentifier, bundle: nil)
        let nib3 = UINib(nibName: SurfingHeaderView.reuseableViewIndetifier, bundle: nil)
        surfingCollectionView.register(nib1, forCellWithReuseIdentifier: FolderCell.cellIdentifier)
        surfingCollectionView.register(nib2, forCellWithReuseIdentifier: SurfingCategoryCell.cellIdentifier)
        surfingCollectionView.register(nib3, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SurfingHeaderView.reuseableViewIndetifier)
        
        surfingCollectionView.dataSource = self
        surfingCollectionView.delegate = self
    }
    
    /// Layout
    
    func createSectionLayout() -> UICollectionViewCompositionalLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            ///인셋이 좌우상하로 들어가기 때문에 원래 의도한 16의 1/2값을 사용함
            let inset: CGFloat = 8
            //            var rows: Int = 2
            var itemsPerRow: Int = 2
            /// height 는 214 고정값이고 item inset을 적용하면 셀 안쪽으로 작아지기 때문에 인셋추가
            var height: CGFloat = 214 + inset * 2
            
            /// 가운데 섹션만 레이아웃이 달라 sectionIndex로 구분
            if sectionIndex == 1 {
                //                rows = 5
                itemsPerRow = 1
                height = 67 + inset * 2
            }
            
            let fraction: CGFloat = 1 / CGFloat(itemsPerRow)
            
            ///item
            var itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(height))
            
            if sectionIndex == 1 {
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .absolute(height))
            }
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            /// Group
            var groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            
            if sectionIndex == 1 {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
            }
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            /// Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            /// Supplementary Item
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItem]
            
            return section
        })
        
        return compositionalLayout
    }
    
    
    
}

extension SurfingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return min(4, topTenFolders.value.count)
        case 1:
            return 5
        case 2:
            return min(4, likedFolders.value.count)
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
            folderCell.update(by: topTenFolders.value[indexPath.row])
            return folderCell
        case 1:
            guard let surfingCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SurfingCategoryCell.cellIdentifier, for: indexPath) as? SurfingCategoryCell else { fatalError() }
            
            return surfingCategoryCell
        case 2:
            guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.cellIdentifier, for: indexPath) as? FolderCell else { fatalError() }
            folderCell.gradientLayer.isHidden = false
            folderCell.update(by: likedFolders.value[indexPath.row])
            return folderCell
        default:
            return UICollectionViewCell()
        }
        
    }
}

extension SurfingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let surfingFolderDetailVC = SurfingFolderDetailViewController.storyboardInstance() else { fatalError() }
            surfingFolderDetailVC.homeNavigationController = homeNavigationController
            
            homeNavigationController?.pushViewController(surfingFolderDetailVC, animated: true)
        case 1:
            guard let categoryDetailVC = CategoryDetailViewController.storyboardInstance() else { fatalError() }
            categoryDetailVC.homeNavigationController = homeNavigationController
            homeNavigationController?.pushViewController(categoryDetailVC, animated: true)
        case 2:
            guard let surfingFolderDetailVC = SurfingFolderDetailViewController.storyboardInstance() else { fatalError() }
            surfingFolderDetailVC.homeNavigationController = homeNavigationController
            homeNavigationController?.pushViewController(surfingFolderDetailVC, animated: true)
        default:
            print("default")
        }
    }
}

extension SurfingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerTitle = ["TOP10 가리비", "카테고리", "찜한 가리비"]
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SurfingHeaderView.reuseableViewIndetifier, for: indexPath) as? SurfingHeaderView else { fatalError() }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped(_:)))
            tapGesture.delegate = self
            headerView.tag = indexPath.section
            headerView.gestureRecognizers?.forEach {headerView.removeGestureRecognizer($0)}
            headerView.addGestureRecognizer(tapGesture)
            headerView.titleLabel.text = headerTitle[indexPath.section]
            return headerView
        default:
            fatalError()
            break
        }
        
    }
    
    @objc private func headerViewTapped(_ sender: UIGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            guard let surfingFolderVC = SurfingFolderViewController.storyboardInstance() else { fatalError() }
            surfingFolderVC.homeNavigationController = homeNavigationController
            surfingFolderVC.surfingFolerType = .topTen
            homeNavigationController?.pushViewController(surfingFolderVC, animated: true)
        case 1:
            guard let categoryDetailVC = CategoryDetailViewController.storyboardInstance() else { fatalError() }
            categoryDetailVC.homeNavigationController = homeNavigationController
            homeNavigationController?.pushViewController(categoryDetailVC, animated: true)
        case 2:
            guard let surfingFolderVC = SurfingFolderViewController.storyboardInstance() else { fatalError() }
            surfingFolderVC.homeNavigationController = homeNavigationController
            surfingFolderVC.surfingFolerType = .liked
            homeNavigationController?.pushViewController(surfingFolderVC, animated: true)
        default:
            print(sender.view?.tag ?? "?" )
        }
    }
}

extension SurfingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
