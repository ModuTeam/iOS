//
//  LinkListViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import UIKit

final class SearchLinkResultViewController: UIViewController {

    @IBOutlet private weak var linkCollectionView: UICollectionView!
 
    var searchedLinks: Observable<[SearchLink.Result]> = Observable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLinkCollectionView()
    }
    
    static func storyboardInstance() -> SearchLinkResultViewController? {
        let storyboard = UIStoryboard(name: SearchLinkResultViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareLinkCollectionView() {
        linkCollectionView.register(UINib(nibName: LinkCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: LinkCell.cellIdentifier)
        linkCollectionView.dataSource = self
        linkCollectionView.delegate = self
    }

}

extension SearchLinkResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedLinks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let linkCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCell.cellIdentifier, for: indexPath) as? LinkCell else { return UICollectionViewCell() }
        linkCell.update(by: searchedLinks.value[indexPath.row])
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
