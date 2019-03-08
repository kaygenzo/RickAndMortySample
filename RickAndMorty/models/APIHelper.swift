//
//  APIHelper.swift
//  RickAndMorty
//
//  Created by Karim Yarboua on 08/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import Foundation

typealias ApiCompletion = (_ next: String?, _ characters: [Character]?, _ errorString: String?) -> Void

class APIHelper {
    private let _baseUrl = "https://rickandmortyapi.com/api/"
    var urlCharacter: String {
        return _baseUrl + "character/"
    }
    
    func getCharacter(_ string: String, completion: ApiCompletion?) {
        if let url = URL(string: string) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    completion?(nil, nil, error!.localizedDescription)
                }
                if data != nil {
                    do {
                        let responseJSON = try JSONDecoder().decode(APIResult.self, from: data!)
                        completion?(responseJSON.info.next, responseJSON.results, nil)
                    } catch {
                        completion?(nil, nil, error.localizedDescription)
                    }
                }
                else {
                    completion?(nil, nil, "No available data")
                }
            }.resume()
        } else {
            completion?(nil, nil, "Invalid URL")
        }
        
    }
}
