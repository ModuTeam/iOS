//
//  LinkCell.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/17.
//

import UIKit

final class LinkCell: UICollectionViewCell {

    static let cellIdentifier: String = "LinkCell"

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var faviconImageView: UIImageView!
    @IBOutlet private(set) weak var editButton: UICustomTagButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 20
    }

    func update(by link: Link) {
        nameLabel.text = link.name
        urlLabel.text = link.url
        
        if let faviconData = link.favicon, let faviconImage = UIImage(data: faviconData) {
            faviconImageView.image = faviconImage
        } else {
            faviconImageView.image = UIImage(named: "seashell")
        }
    }
}
