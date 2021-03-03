//
//  HTMLParserService.swift
//  LinkMoa
//
//  Created by won heo on 2021/02/26.
//

import Foundation

struct HTMLParserService {
    
    func fetchTitle(urlString: String, completionhHandler: @escaping ((String?) -> ())) {
        guard let url = URL(string: urlString) else {
            completionhHandler(nil)
            return
        }
        
        URLSession(configuration: .default).dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completionhHandler(nil)
                return
            }
            
            guard let data = data else {
                print("no data")
                completionhHandler(nil)
                return
            }
            
            if let content = String(data: data, encoding: .utf8), let range = content.range(of: "<title>.*?</title>", options: .regularExpression, range: nil, locale: nil) {
                let title = content[range].replacingOccurrences(of: "</?title>", with: "", options: .regularExpression, range: nil)
                completionhHandler(title)
            } else {
                completionhHandler(nil)
            }
        }.resume()
    }
}
