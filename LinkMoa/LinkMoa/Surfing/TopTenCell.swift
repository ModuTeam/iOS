//
//  TopTenCell.swift
//  LinkMoa
//
//  Created by Beomcheol Kwon on 2021/03/04.
//

import UIKit
///삭제예정
class TopTenCell: UICollectionViewCell {

    static let cellIdentifier: String = "TopTenCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }

}
