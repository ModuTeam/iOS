//
//  FolderSearchViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import UIKit

final class SearchFolderViewController: UIViewController {

    @IBOutlet private weak var tabBarCollectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    private var tabBarSectionNames: [String] = ["폴더(6개)", "링크(2개)"]
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private var pages: [UIViewController] = []
    private var folderListViewController: FolderListViewController?
    private var linkListViewController: LinkListViewController?
    
    private var selectedTabView: UIView = UIView()
    private var isNotInitFirstTabCell: Bool = true
    private var isNotInitSelectTab: Bool = true

    private let searchFolderViewModel: SearchFolderViewModel = SearchFolderViewModel()
    private var folders: [Folder] = [] {
        didSet {
            guard let keyword = self.searchTextField.text else { return }

            if keyword.isEmpty {
                self.filterFolders = folders
            } else {
                self.filterFolders = folders.filter({$0.name.hasPrefix(keyword)})
            }
        }
    }
    
    private var filterFolders: [Folder] = [] {
        didSet {
            self.tabBarSectionNames[0] = "폴더(\(filterFolders.count))개"
            self.tabBarCollectionView.reloadData()
            self.folderListViewController?.folders = filterFolders
            
            if isNotInitSelectTab {
                self.prepareSelectedTabView()
                self.isNotInitSelectTab.toggle()
            }
        }
    }
    
    private var links: [Link] = [] {
        didSet {
            guard let keyword = self.searchTextField.text else { return }

            if keyword.isEmpty {
                self.filterLinks = links
            } else {
                self.filterLinks = links.filter({$0.name.hasPrefix(keyword)})
            }
        }
    }
    
    private var filterLinks: [Link] = [] {
        didSet {
            self.tabBarSectionNames[1] = "링크(\(filterLinks.count))개"
            self.tabBarCollectionView.reloadData()
            self.linkListViewController?.links = filterLinks
            
            if isNotInitSelectTab {
                self.prepareSelectedTabView()
                self.isNotInitSelectTab.toggle()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTabBarCollectionView()
        preparePageViewController()
        prepareSearchTextField()
        
        bind()
        searchFolderViewModel.fetchFolders()
        searchFolderViewModel.fetchLinks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind() {
        searchFolderViewModel.outputs.folders.bind { [weak self] results in
            guard let self = self else { return }
            self.folders = results
        }
        
        searchFolderViewModel.outputs.links.bind { [weak self] results in
            guard let self = self else { return }
            self.links = results
        }
    }
    
    private func preparePageViewController() {
        guard let folderListVc = FolderListViewController.storyboardInstance() else { fatalError() }
        guard let linkListVc = LinkListViewController.storyboardInstance() else { fatalError() }
        
        folderListViewController = folderListVc
        linkListViewController = linkListVc
        // homeFolderVc.homeNavigationController = navigationController as? HomeNavigationController
        
        pages = [folderListVc, linkListVc]
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([folderListVc], direction: .forward, animated: true, completion: nil)
        
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
    
    private func prepareSelectedTabView() {
        let label = UILabel()
        label.text = tabBarSectionNames[0]
        label.font = UIFont(name: "NotoSansKR-Medium", size: 19)
        let size = label.intrinsicContentSize.width
        
        selectedTabView.frame = CGRect(x: 0, y: 38, width: size, height: 3)
        selectedTabView.backgroundColor = UIColor(rgb: 0x4B4B4B)
        tabBarCollectionView.addSubview(selectedTabView)
    }
    
    private func prepareTabBarCollectionView() {
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        tabBarCollectionView.register(UINib(nibName: TabBarTitleCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TabBarTitleCell.cellIdentifier)
    }
    
    private func scrollSelectedTabView(scrollToIndexPath indexPath: IndexPath) {
        let homeNavVc = navigationController as? HomeNavigationController
        homeNavVc?.addButtonView.isHidden = (indexPath.item == 0) ? false : true
        
        let prevIndexPath = IndexPath(item: indexPath.item == 0 ? 1 : 0, section: 0)
        
        UIView.animate(withDuration: 0.15) {
            if let destinationCell = self.tabBarCollectionView.cellForItem(at: indexPath) as? TabBarTitleCell {
                self.selectedTabView.frame.size.width = destinationCell.frame.width
                self.selectedTabView.frame.origin.x = destinationCell.frame.origin.x
                
                destinationCell.titleLabel.layer.opacity = 1
                destinationCell.titleLabel.textColor = UIColor(rgb: 0x303335)
            }
            
            if let startCell = self.tabBarCollectionView.cellForItem(at: prevIndexPath) as? TabBarTitleCell {
                startCell.titleLabel.layer.opacity = 0.3
                startCell.titleLabel.textColor = UIColor(rgb: 0x4B4B4B)
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
        if let keyword = sender.text, !keyword.isEmpty {
            filterFolders = folders.filter({ $0.name.hasPrefix(keyword) })
            filterLinks = links.filter({ $0.name.hasPrefix(keyword) })
        } else {
            filterFolders = folders
            filterLinks = links
        }
    }
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchFolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarSectionNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarTitleCell.cellIdentifier, for: indexPath) as? TabBarTitleCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0, isNotInitFirstTabCell { // first cell init
            titleCell.titleLabel.layer.opacity = 1
            titleCell.titleLabel.textColor = UIColor(rgb: 0x303335)
            isNotInitFirstTabCell.toggle()
        }
        
        titleCell.titleLabel.text = tabBarSectionNames[indexPath.item]
        return titleCell
    }
}

extension SearchFolderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollSelectedTabView(scrollToIndexPath: indexPath)
        setPageController(setToIndexPath: indexPath)
    }
}

extension SearchFolderViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        if index == 1 {
            let prevIndex = index - 1
            // currentPage = prevIndex
            // let navVc = navigationController as? HomeNavigationController
            // navVc?.addButtonView.isHidden = true

            return pages[prevIndex]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }

        if index == 0 {
            let nextIndex = index + 1
            // currentPage = nextIndex
            // let navVc = navigationController as? HomeNavigationController
            return pages[nextIndex]
        }
        
        return nil
    }
}

extension SearchFolderViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVc = pageViewController.viewControllers?.first else { return }
        guard let index = pages.lastIndex(of: currentVc) else { return }

        scrollSelectedTabView(scrollToIndexPath: IndexPath(item: index, section: 0))
    }
}
