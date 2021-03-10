//
//  SurfingFolderDetailViewController.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/06.
//

import UIKit

class SurfingFolderDetailViewController: UIViewController {
    
    @IBOutlet weak var folderTitleLabel: UILabel!
    @IBOutlet weak var tagStackView: UIStackView!
    @IBOutlet weak var linkCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var linkCollectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    private var links: [Link] = []
    weak var homeNavigationController: HomeNavigationController?
    private var blurVC: BackgroundBlur? {
        return navigationController as? BackgroundBlur
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        prepareLinkCollectionView()
        bind()
        update() // data update by presenting VC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareNavigationBar()
        prepareNavigationItem()
    }
    
    static func storyboardInstance() -> SurfingFolderDetailViewController? {
        let storyboard = UIStoryboard(name: SurfingFolderDetailViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func bind() {
       
    }
    
    private func update() {
       
    }
    
    private func updateTagStackView(tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }

        for tag in tags {
            let label = UILabel(frame: CGRect.zero)
            label.text = "#" + tag
            label.textColor = UIColor.white
            label.font = UIFont(name: "NotoSansKR-Regular", size: 14)

            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func prepareLinkCollectionView() {
        linkCollectionView.register(UINib(nibName: LinkCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: LinkCell.cellIdentifier)
        linkCollectionView.dataSource = self
        linkCollectionView.delegate = self
    }
    
    private func prepareNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
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

    @objc private func folderShareButtonTapped() {
        
    }
    
    @objc private func searchButtonTapped() {
        guard let searchLinkVC = SearchInFolderViewController.storyboardInstance() else { return }
        
        searchLinkVC.modalTransitionStyle = .crossDissolve
        searchLinkVC.modalPresentationStyle = .overCurrentContext
        
        homeNavigationController?.present(searchLinkVC, animated: true, completion: nil)
    }
   
}

extension SurfingFolderDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SurfingFolderDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let linkCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCell.cellIdentifier, for: indexPath) as? LinkCell else { return UICollectionViewCell() }
        
       
        let link = links[indexPath.item]
        
        linkCell.update(by: link)
        // linkCell.editButton.customTag = link.id
        
        return linkCell
    }
}

extension SurfingFolderDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = links[indexPath.item]
        
        //사파리로 링크열기
        if let url = URL(string: link.url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension SurfingFolderDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - (18 * 2)
        let height: CGFloat = 83
        return CGSize(width: width, height: height)
    }
}
