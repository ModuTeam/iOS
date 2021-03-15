//
//  SearchMainViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import UIKit

enum SearchTarget {
    case my
    case surf
}

final class SearchMainViewController: UIViewController {
    
    @IBOutlet private weak var topMenuCollectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!

    private var searchFolderViewModel: SearchFolderViewModel = SearchFolderViewModel()
    private var searchedFolders: Observable<[SearchFolder.Result]> = Observable([])
    private var searchedLinks: Observable<[SearchLink.Result]> = Observable([])
    private var searchWord: String = ""
    private var currentPage: Int = 0
    
    private lazy var topMenuSectionNames: [String] = ["폴더(0개)", "링크(0개)"]
    private var folderCount: Int = 0
    private var linkCount: Int = 0
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private var pages: [UIViewController] = []
    private var searchFolderResultVC: SearchFolderResultViewController?
    private var searchLinkResultVC: SearchLinkResultViewController?
    
    private var selectedTopMenuView: UIView = UIView()
    private var isTopMenuSelected: Bool = false
    private var isTopMenuViewPresented: Bool = false
    
    var searchTarget: SearchTarget = .my

    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchTarget()
        prepareTopMenuCollectionView()
        preparePageViewController()
        prepareSearchTextField()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func bind() {
        searchFolderViewModel.inputs.searchFolder(word: searchWord)
        searchFolderViewModel.inputs.searchLink(word: searchWord)
        
        searchFolderViewModel.outputs.searchedFolders.bind { [weak self] results in
            guard let self = self else { return }
            self.searchedFolders.value = results
            self.folderCount = results.count
            self.topMenuSectionNames[0] = "폴더(\(results.count.toAbbreviationString))개"
            self.topMenuCollectionView.reloadData()
            self.reload(index: self.currentPage)
        }
        searchFolderViewModel.outputs.searchedLinks.bind { [weak self] results in
            guard let self = self else { return }
            print(results)
            self.searchedLinks.value = results
            self.linkCount = results.count
            self.topMenuSectionNames[1] = "링크(\(results.count.toAbbreviationString))개"
            self.topMenuCollectionView.reloadData()
            self.reload(index: self.currentPage)
        }
    }
    
    private func prepareSearchTarget() {
        guard let nav = navigationController as? SearchMainNavigationController else { fatalError() }
        searchTarget = nav.searchTarget
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func preparePageViewController() {
        guard let folderListVC = SearchFolderResultViewController.storyboardInstance() else { fatalError() }
        guard let linkListVC = SearchLinkResultViewController.storyboardInstance() else { fatalError() }
        
        folderListVC.searchTarget = searchTarget
        searchFolderResultVC = folderListVC
        searchLinkResultVC = linkListVC
        
        pages = [folderListVC, linkListVC]
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([folderListVC], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        containerView.addSubview(pageViewController.view)
        constaintPageViewControllerView()
    }
    
    private func constaintPageViewControllerView() {
        let pageContentView: UIView = pageViewController.view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        pageContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pageContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pageContentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pageContentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func prepareSelectedTopMenuView() {
        let label = UILabel()
        label.text = topMenuSectionNames[0]
        label.font = UIFont(name: "NotoSansKR-Medium", size: 19)
        let size = label.intrinsicContentSize.width
        
        selectedTopMenuView.frame = CGRect(x: 0, y: 38, width: size, height: 3)
        selectedTopMenuView.backgroundColor = UIColor.linkMoaGreyColor
        topMenuCollectionView.addSubview(selectedTopMenuView)
    }
    
    private func prepareTopMenuCollectionView() {
        topMenuCollectionView.dataSource = self
        topMenuCollectionView.delegate = self
        topMenuCollectionView.register(UINib(nibName: TopMenuCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TopMenuCell.cellIdentifier)
    }
    
    private func scrollSelectedTopMenuView(scrollToIndexPath indexPath: IndexPath) {
        let homeNC = navigationController as? HomeNavigationController
        homeNC?.addButtonView.isHidden = (indexPath.item == 0) ? false : true
        
        let prevIndexPath = IndexPath(item: indexPath.item == 0 ? 1 : 0, section: 0)
        
        UIView.animate(withDuration: 0.15) {
            if let destinationCell = self.topMenuCollectionView.cellForItem(at: indexPath) as? TopMenuCell {
                self.selectedTopMenuView.frame.size.width = destinationCell.frame.width
                self.selectedTopMenuView.frame.origin.x = destinationCell.frame.origin.x
                
                destinationCell.titleLabel.layer.opacity = 1
                destinationCell.titleLabel.textColor = .linkMoaBlackColor
            }
            
            if let startCell = self.topMenuCollectionView.cellForItem(at: prevIndexPath) as? TopMenuCell {
                startCell.titleLabel.layer.opacity = 0.3
                startCell.titleLabel.textColor = .linkMoaGreyColor
            }
        }
    }
    
    private func setPageController(setToIndexPath indexPath: IndexPath) {
        let direction: UIPageViewController.NavigationDirection = indexPath.item == 0 ? .reverse : .forward
        
        pageViewController.setViewControllers([pages[indexPath.item]], direction: direction, animated: true, completion: nil)

    }
    
    private func prepareSearchTextField() {
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        switch searchTarget {
        case .my:
            DEBUG_LOG(searchTarget)
        case .surf:
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerFunc), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerFunc() {
        guard let word = searchTextField.text else { return }
        searchWord = word
        if searchWord == searchTextField.text {
            timer.invalidate()
        }
        bind()
    }
    
    private func reload(index: Int) {
        switch index {
        case 0:
            searchFolderResultVC?.searchedFolders = searchedFolders
            searchFolderResultVC?.folderCollectionView.reloadData()
        case 1:
            searchLinkResultVC?.searchedLinks = searchedLinks
            searchLinkResultVC?.linkCollectionView.reloadData()
        default:
            return
        }
    }
    
}

extension SearchMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topMenuSectionNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: TopMenuCell.cellIdentifier, for: indexPath) as? TopMenuCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0, !isTopMenuSelected { // first cell init
            titleCell.titleLabel.layer.opacity = 1
            titleCell.titleLabel.textColor = .linkMoaBlackColor
            isTopMenuSelected.toggle()
        }

        titleCell.titleLabel.text = topMenuSectionNames[indexPath.item]
        return titleCell
    }
}

extension SearchMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollSelectedTopMenuView(scrollToIndexPath: indexPath)
        setPageController(setToIndexPath: indexPath)
        currentPage = indexPath.item
        reload(index: currentPage)
    }
}

extension SearchMainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        if index == 1 {
            let prevIndex = index - 1
            return pages[prevIndex]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        if index == 0 {
            let nextIndex = index + 1
            return pages[nextIndex]
        }
        
        return nil
    }
}

extension SearchMainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        guard let index = pages.lastIndex(of: currentVC) else { return }
        
        scrollSelectedTopMenuView(scrollToIndexPath: IndexPath(item: index, section: 0))
        currentPage = index
        reload(index: currentPage)
        
    }
}
