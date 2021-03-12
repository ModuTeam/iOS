//
//  LinkPresentaionService.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/19.
//

import UIKit
import LinkPresentation
import Alamofire
import Kanna

public struct LinkPresentaionService {

    private let googleFaviconURLString: String = "https://www.google.com/s2/favicons?sz=64&domain_url="
    
    // 사용 안함
    func fetchLinkMetaData(urlString: String, completionHandler: @escaping (UIImage?, UIImage?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        let provider: LPMetadataProvider = LPMetadataProvider()
        provider.timeout = 5
        
        let metaDataGroup = DispatchGroup()
        let dispatchGroup = DispatchQueue.global()
        var webImage: UIImage?
        var iconImage: UIImage?
        
        provider.startFetchingMetadata(for: url, completionHandler: { metadata, error in
            if let imageProvider = metadata?.imageProvider { // web image
                metaDataGroup.enter()
                dispatchGroup.async(group: metaDataGroup, execute: {
                    imageProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        guard error == nil else {
                            metaDataGroup.leave()
                            // print(error)
                            return
                        }
                        
                        if let image = image as? UIImage {
                            webImage = image
                        }
                        
                        metaDataGroup.leave()
                    }
                })
            }
            
            metaDataGroup.enter()
            dispatchGroup.async(group: metaDataGroup, execute: { // web favicon
                linkFavicon(targetURLString: urlString, completionHandler: { image in
                    iconImage = image
                    metaDataGroup.leave()
                })
            })
            
            metaDataGroup.notify(queue: dispatchGroup, execute: {
                completionHandler(webImage, iconImage)
            })
        })
    }
    
    // 사용 안함
    func linkFavicon(targetURLString urlString: String, completionHandler: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: googleFaviconURLString + urlString) else { return }
        
        URLSession(configuration: .default).dataTask(with: url, completionHandler: { (data, response, error) in
            if let _ = error {
                completionHandler(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        }).resume()
    }
    
    // 사용 안함
    func fetchTitle(urlString: String, completionHandler: @escaping (String?) -> ()) {
        guard let url = URL(string: urlString) else {
            completionHandler(nil)
            return
        }
        
        let provider: LPMetadataProvider = LPMetadataProvider()
        provider.timeout = 5
        
        provider.startFetchingMetadata(for: url, completionHandler: { metadata, error in
            if let error = error {
                print(error)
                completionHandler(nil)
                return
            }
            
            completionHandler(metadata?.title)
        })
    }
    
    // completionHandler: (타이틀, 웹 이미지 URL, 파비콘 URL)
    func fetchMetaDataURL(targetURLString URLString: String, completionHandler: @escaping (WebMetaData?) -> ()) {
        guard let url = URL(string: URLString) else { return }
        
        var title: String? = nil
        var image: String? = nil
        let favicon = googleFaviconURLString + URLString
        
        AF.request(url).responseString(completionHandler: { response in
            switch response.result {
            case .success(let htmlString):
                do {
                    let doc = try HTML(html: htmlString, encoding: .utf8)

                    for link in doc.xpath("//meta[@property='og:title']") {
                        if let contentTitle = link["content"] {
                            title = contentTitle
                            break
                        }
                    }
                    
                    for link in doc.xpath("//meta[@property='og:image']") {
                        if let imageURLString = link["content"] {
                            image = imageURLString
                            break
                        }
                    }
                    
                    completionHandler(WebMetaData(title: title, webPreviewURLString: image, faviconURLString: favicon))
                } catch let error {
                    print(error)
                    completionHandler(WebMetaData(title: nil, webPreviewURLString: nil, faviconURLString: nil))
                }

            case .failure(let error):
                print(error)
                completionHandler(WebMetaData(title: nil, webPreviewURLString: nil, faviconURLString: nil))
            }
        })
    }
}
