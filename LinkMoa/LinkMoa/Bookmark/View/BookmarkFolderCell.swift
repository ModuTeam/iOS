//
//  HomeFolderCellCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/03.
//

import UIKit

final class BookmarkFolderCell: UICollectionViewCell {

    static let cellIdentifier: String = "BookmarkFolderCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var webPreviewImageView: UIImageView!
    @IBOutlet private weak var lockImageView: UIImageView!
    @IBOutlet private(set) weak var editButton: UICustomTagButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        resetComponents()
    }
    
    private func resetComponents() {
        webPreviewImageView.image = nil
        lockImageView.isHidden = true
    }
    
    func update(by folder: Folder) {
        titleLabel.text = folder.name
        countLabel.text = String(folder.count)
        
        if folder.isShared {
            lockImageView.isHidden = true
        } else {
            lockImageView.isHidden = false
        }
        
        if let previewData = Array(folder.links).compactMap({ $0.webPreview }).last,
           let previewImage = UIImage(data: previewData) {
            
            if folder.isShared {
                webPreviewImageView.image = previewImage
            } else {
                webPreviewImageView.image = previewImage.greyScale
            }
        } else {
            webPreviewImageView.image = nil
        }
    }
}

