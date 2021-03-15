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
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var folderIndex = 1
    weak var homeNavigationController: HomeNavigationController?
    
    private let viewModel: SurfingFolderDetailViewModel = SurfingFolderDetailViewModel()
    
    var folderDetail: Observable<FolderDetail.Result> = Observable(FolderDetail.Result(userIndex: 0, folderIndex: 0, name: "", type: "", likeCount: 0, linkCount: 0, folderUpdatedAt: "", hashTagList: [], linkList: []))
    
    
    private var blurVC: BackgroundBlur? {
        return navigationController as? BackgroundBlur
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLinkCollectionView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareNavigationBar()
        prepareNavigationItem()
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        viewModel.inputs.likeFolder(folder: folderIndex)
        viewModel.outputs.folderDetail.bind { [weak self] results  in
            guard let self = self else { return }
            print("topTenFolders", results)
            self.folderDetail.value = results
            self.linkCollectionView.reloadData()
            self.updateUI(folderDetail: results)
        }
    }
    static func storyboardInstance() -> SurfingFolderDetailViewController? {
        let storyboard = UIStoryboard(name: SurfingFolderDetailViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func bind() {
        viewModel.inputs.fetchFolderDetail(folder: folderIndex)
        viewModel.outputs.folderDetail.bind { [weak self] results  in
            guard let self = self else { return }
            print("topTenFolders", results)
            self.folderDetail.value = results
            self.linkCollectionView.reloadData()
            self.updateUI(folderDetail: results)
        }
    }
    
    private func updateUI(folderDetail: FolderDetail.Result) {
        self.folderTitleLabel.text = folderDetail.name
        self.userNameLabel.text = "folderDetail.userIndex"
        self.linkCountLabel.text = folderDetail.linkCount.toAbbreviationString
        self.likeCountLabel.text = folderDetail.likeCount.toAbbreviationString
        let tags: [String] = folderDetail.hashTagList.map {$0.name}
        updateTagStackView(tags: tags)
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
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "editDot"), style: .plain, target: self, action: #selector(menuButtonTapped))
        shareBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        shareBarButtonItem.tintColor = .white
        
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        searchBarButtonItem.tintColor = .white
        
        navigationItem.rightBarButtonItems = [shareBarButtonItem, searchBarButtonItem]
    }
    
    @objc private func menuButtonTapped() {
        guard let editVC = EditBottomSheetViewController.storyboardInstance() else { return }
        
        editVC.modalPresentationStyle = .overCurrentContext
        editVC.modalTransitionStyle = .coverVertical
        editVC.isIncludeRemoveButton = true // 마지막 label red
        
        editVC.completionHandler = { [weak self] in
            self?.blurVC?.fadeOutBackgroundViewAnimation()
        }
        
        editVC.actions = ["URL 공유하기", "신고하기"]
        editVC.handlers = [
            { [weak self] _ in
                guard let self = self else { return }
                guard let folderName = self.folderTitleLabel.text else { return }
                
                let shareItem = folderName + "\n\n" + self.folderDetail.value.linkList.map { "\($0.name)\n\($0.url)\n\n" }.joined()
                let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
                activityController.excludedActivityTypes = [.saveToCameraRoll, .print, .assignToContact, .addToReadingList]
                
                self.present(activityController, animated: true, completion: nil)
            },
            { [weak self] _ in // 삭제하기
                guard let self = self else { return }

            print("신고하기")
            }
        ]
        
        blurVC?.fadeInBackgroundViewAnimation()
        navigationController?.present(editVC, animated: true)
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
        return folderDetail.value.linkCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let linkCell = collectionView.dequeueReusableCell(withReuseIdentifier: LinkCell.cellIdentifier, for: indexPath) as? LinkCell else { return UICollectionViewCell() }
        
        let links = folderDetail.value.linkList
        let link = links[indexPath.item]
        
        linkCell.update(by: link)
        // linkCell.editButton.customTag = link.id
        
        return linkCell
    }
}

extension SurfingFolderDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let links = folderDetail.value.linkList
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
