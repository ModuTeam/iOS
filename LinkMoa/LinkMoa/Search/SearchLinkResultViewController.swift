//
//  LinkListViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import UIKit

final class SearchLinkResultViewController: UIViewController {

    @IBOutlet weak var linkCollectionView: UICollectionView!
 
    private let searchLinkViewModel: SearchLinkViewModel = SearchLinkViewModel()
    
    weak var searchMainVC: SearchMainViewController?
    var searchedLinks: [SearchLink.Result] = []
    var searchTarget: SearchTarget = .my
    
    var searchWord: String = "" {
        didSet {
            print(searchWord)
            searchLinkViewModel.searchLink(word: searchWord)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLinkCollectionView()
        bind()
    }
    
    static func storyboardInstance() -> SearchLinkResultViewController? {
        let storyboard = UIStoryboard(name: SearchLinkResultViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func bind() {
        searchLinkViewModel.outputs.searchedLinks.bind { [weak self] result in
            guard let self = self else { return }
            self.searchedLinks = result
            self.linkCollectionView.reloadData()
        }
    }
    
    private func prepareLinkCollectionView() {
        linkCollectionView.register(UINib(nibName: LinkCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: LinkCell.cellIdentifier)
        linkCollectionView.dataSource = self
        linkCollectionView.delegate = self
    }

}

extension SearchLinkResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let linkCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCell.cellIdentifier, for: indexPath) as? LinkCell else { return UICollectionViewCell() }
        linkCell.update(by: searchedLinks[indexPath.row])
        return linkCell
    } 
}

extension SearchLinkResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - (18 * 2)
        let height: CGFloat = 83
        return CGSize(width: width, height: height)
    }
}
