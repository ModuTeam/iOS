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
        guard let saveSucceedBottomVc = SaveSucceedBottomViewController.storyboardInstance() else { return }
        
        saveSucceedBottomVc.modalPresentationStyle = .overCurrentContext
        saveSucceedBottomVc.modalTransitionStyle = .coverVertical
        saveSucceedBottomVc.completionHandler = completeHandler
        
        self.present(saveSucceedBottomVc, animated: true, completion: nil)
    }
    
    func alertRemoveSucceedView(completeHandler: (() -> ())?) {
        guard let removeSucceedBottomVc = RemoveSucceedBottomViewController.storyboardInstance() else { return }
        
        removeSucceedBottomVc.modalPresentationStyle = .overCurrentContext
        removeSucceedBottomVc.modalTransitionStyle = .coverVertical
        removeSucceedBottomVc.completionHandler = completeHandler

        self.present(removeSucceedBottomVc, animated: true, completion: nil)
    }
    
    func alertRemoveRequestView(folder: Folder, completeHandler: (() -> ())?, removeHandler: (() -> ())?) {
        guard let removeRequestView = RemoveRequestBottomViewController.storyboardInstance() else { return }
        
        removeRequestView.modalPresentationStyle = .overCurrentContext
        removeRequestView.modalTransitionStyle = .coverVertical
        removeRequestView.completionHandler = completeHandler
        removeRequestView.removeHandler = removeHandler
        removeRequestView.folder = folder
        
        self.present(removeRequestView, animated: true, completion: nil)
    }
}
