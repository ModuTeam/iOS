//
//  ShareFolderSelectionViewController.swift
//  LinkMoaShareExtension
//
//  Created by won heo on 2021/02/26.
//

import UIKit

class ShareFolderSelectionViewController: UIViewController, CustomAlert {

    @IBOutlet private weak var folderSelectCollectionView: UICollectionView!
    
    private let shareFolderSelectionViewModel = ShareFolderSelectionViewModel()
    private var folders: [Folder] = []
    var selectHandler: ((Folder) -> ())?
    
    private var blurVC: BackgroundBlur? {
        return navigationController as? BackgroundBlur
    }
    
    static func storyboardInstance() -> ShareFolderSelectionViewController? {
        let storyboard = UIStoryboard(name: ShareFolderSelectionViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        preparefolderSelectCollectionView()
        
        bind()
        shareFolderSelectionViewModel.fetchFolders()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func bind() {
        shareFolderSelectionViewModel.outputs.folders.bind { [weak self] results in
            guard let self = self else { return }
            self.folders = results
            self.folderSelectCollectionView.reloadData()
        }
    }
    
//    private func alertSucceedView() {
//        guard let saveSucceedBottomVc = SaveSucceedBottomViewController.storyboardInstance() else { return }
//
//        saveSucceedBottomVc.modalPresentationStyle = .overCurrentContext
//        saveSucceedBottomVc.modalTransitionStyle = .coverVertical
//        saveSucceedBottomVc.completeHandler = { [weak self] in
//            self?.blurVc?.stopBackGroundView()
//        }
//
//        // self.homeNavigationController?.animateBackGroundView()
//        blurVc?.startBackGroundView()
//        self.present(saveSucceedBottomVc, animated: true, completion: nil)
//    }
    
    private func prepareNavigationBar() {
        let rightButtonTiem = UIBarButtonItem(image: UIImage(named: "createFolder"), style: .plain, target: self, action: #selector(addFolderButtonTapped))
        rightButtonTiem.tintColor = UIColor(rgb: 0x5c5c5c)
        navigationItem.rightBarButtonItem = rightButtonTiem
    }
    
    private func preparefolderSelectCollectionView() {
        folderSelectCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 50, right: 15)
        folderSelectCollectionView.register(UINib(nibName: BookmarkFolderCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: BookmarkFolderCell.cellIdentifier)
    
        folderSelectCollectionView.dataSource = self
        folderSelectCollectionView.delegate = self
    }
    
    @objc private func addFolderButtonTapped() {
        guard let shareAddFolderVc = ShareAddFolderViewController.storyboardInstance() else { return }
//        let shareAddFolderVc = UIViewController()
//        shareAddFolderVc.view.backgroundColor = .red
        shareAddFolderVc.saveHandler = { [weak self] in
            guard let self = self else { return }
            
            self.blurVC?.fadeInBackgroundViewAnimation()
            self.alertSucceedView(completeHandler: { self.blurVC?.fadeOutBackgroundViewAnimation() })
        }
        shareAddFolderVc.modalPresentationStyle = .overCurrentContext
        present(shareAddFolderVc, animated: true, completion: nil)
    }
}

extension ShareFolderSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkFolderCell.cellIdentifier, for: indexPath) as? BookmarkFolderCell else { return UICollectionViewCell() }
        
        let folder = folders[indexPath.item]
        folderCell.update(by: folder)
        
        return folderCell
    }
}

extension ShareFolderSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folder = folders[indexPath.item]

        selectHandler?(folder)
        navigationController?.popViewController(animated: true)
    }
}

extension ShareFolderSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 214
        
        return CGSize(width: width, height: height)
    }
}
