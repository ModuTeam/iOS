//
//  HomeViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/01/31.
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var tabBarCollectionView: UICollectionView!
    @IBOutlet private weak var containerView: UIView!
    
    private let tabBarSectionNames: [String] = ["나의 가리비", "서핑하기"]
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private var pages: [UIViewController] = []
    private var selectedTabView: UIView = UIView()
    private var isNotInitFirstTabCell: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preparePageViewController()
        prepareTabBarCollectionView()
        prepareSelectedTabView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    private func preparePageViewController() {
        guard let homeFolderVc = FolderViewController.storyboardInstance() else { fatalError() }
        
        guard let surfingVc = SurfingViewController.storyboardInstance() else { fatalError() }
        
        homeFolderVc.homeNavigationController = navigationController as? HomeNavigationController
        
        pages = [homeFolderVc, surfingVc]
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([homeFolderVc], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        containerView.addSubview(pageViewController.view)
        constaintPageViewControllerView()
    }
    
    private func prepareTabBarCollectionView() {
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        tabBarCollectionView.register(UINib(nibName: TabBarTitleCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: TabBarTitleCell.cellIdentifier)
    }
    
    private func prepareSelectedTabView() {
        selectedTabView.frame = CGRect(x: 18, y: 47, width: 97.6, height: 3)
        selectedTabView.backgroundColor = UIColor(rgb: 0x4B4B4B)
        tabBarCollectionView.addSubview(selectedTabView)
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
    
    @IBAction private func searchButtonTapped() {
        guard let searchFolderNavVc = SearchFolderNavigationViewController.storyboardInstance() else { return }
        
        searchFolderNavVc.modalTransitionStyle = .crossDissolve
        searchFolderNavVc.modalPresentationStyle = .fullScreen
        
        present(searchFolderNavVc, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollSelectedTabView(scrollToIndexPath: indexPath)
        setPageController(setToIndexPath: indexPath)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        if index == 1 {
            let prevIndex = index - 1
            let navVc = navigationController as? HomeNavigationController
            navVc?.addButtonView.isHidden = true

            return pages[prevIndex]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        if index == 0 {
            let nextIndex = index + 1
            let navVc = navigationController as? HomeNavigationController
            navVc?.addButtonView.isHidden = false
            return pages[nextIndex]
        }
        
        return nil
    }
}

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVc = pageViewController.viewControllers?.first else { return }
        guard let index = pages.lastIndex(of: currentVc) else { return }

        scrollSelectedTabView(scrollToIndexPath: IndexPath(item: index, section: 0))
    }
}
