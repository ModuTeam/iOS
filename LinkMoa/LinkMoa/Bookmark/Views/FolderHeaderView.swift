//
//  FolderheaderView.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/03.
//

import UIKit

final class FolderHeaderView: UICollectionReusableView {

    static let reuseableViewIndetifier: String = "FolderHeaderView"
    
    @IBOutlet private(set) weak var countTitleLabel: UILabel!
    @IBOutlet private(set) weak var sortButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(by count: Int) {
        guard let font = UIFont(name: "NotoSansKR-Regular", size: 14) else { return }
        
        let folderString = "\(count)개의 폴더"
        let mutableString =  NSMutableAttributedString(string: folderString, attributes: [NSAttributedString.Key.font: font])
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.linkMoaFolderCountGreyColor, range: NSRange(location: folderString.count - 4, length: 4))
        
        countTitleLabel.attributedText = mutableString
    }
}
