//
//  CustomAlert.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/27.
//

import UIKit

protocol CustomAlert {}

extension CustomAlert where Self: UIViewController {
    func alertSucceedView(completeHandler: (() -> ())?) {
        guard let saveSucceedBottomVC = SaveSucceedBottomViewController.storyboardInstance() else { return }
        
        saveSucceedBottomVC.modalPresentationStyle = .overCurrentContext
        saveSucceedBottomVC.modalTransitionStyle = .coverVertical
        saveSucceedBottomVC.completionHandler = completeHandler
        
        self.present(saveSucceedBottomVC, animated: true, completion: nil)
    }
    
    func alertRemoveSucceedView(completeHandler: (() -> ())?) {
        guard let removeSucceedBottomVC = RemoveSucceedBottomViewController.storyboardInstance() else { return }
        
        removeSucceedBottomVC.modalPresentationStyle = .overCurrentContext
        removeSucceedBottomVC.modalTransitionStyle = .coverVertical
        removeSucceedBottomVC.completionHandler = completeHandler

        self.present(removeSucceedBottomVC, animated: true, completion: nil)
    }
    
    func alertRemoveRequestView(folderName: String, completeHandler: (() -> ())?, removeHandler: (() -> ())?) {
        guard let removeRequestVC = RemoveRequestBottomViewController.storyboardInstance() else { return }
        
        removeRequestVC.modalPresentationStyle = .overCurrentContext
        removeRequestVC.modalTransitionStyle = .coverVertical
        removeRequestVC.completionHandler = completeHandler
        removeRequestVC.removeHandler = removeHandler
        removeRequestVC.folderName = folderName
        
        self.present(removeRequestVC, animated: true, completion: nil)
    }
}
