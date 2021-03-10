//
//  LinkListViewController.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/25.
//

import UIKit

final class SearchLinkResultViewController: UIViewController {

    @IBOutlet private weak var linkCollectionView: UICollectionView!
    
    static func storyboardInstance() -> SearchLinkResultViewController? {
        let storyboard = UIStoryboard(name: SearchLinkResultViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    var links: [Link] = [] {
        didSet {
            guard let linkCollectionView = linkCollectionView else { return }
            linkCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLinkCollectionView()
        // Do any additional setup after loading the view.
    }
    
    private func prepareLinkCollectionView() {
        linkCollectionView.register(UINib(nibName: LinkCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: LinkCell.cellIdentifier)
        linkCollectionView.dataSource = self
        linkCollectionView.delegate = self
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchLinkResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let linkCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCell.cellIdentifier, for: indexPath) as? LinkCell else { return UICollectionViewCell() }
        
        // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellEditButtonTapped(_:)))
        let link = links[indexPath.item]
        
        linkCell.update(by: link)
        // linkCell.editButton.addGestureRecognizer(tapGesture)
        // linkCell.editButton.customTag = link.id
        
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
