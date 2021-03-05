//
//  SurfingCategoryCell.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/05.
//

import UIKit

class SurfingCategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    static let cellIdentifier: String = "SurfingCategoryCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImageView.layer.cornerRadius = 65/2
    }

}
