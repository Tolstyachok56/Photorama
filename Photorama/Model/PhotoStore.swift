//
//  PhotoStore.swift
//  Photorama
//
//  Created by Виктория Бадисова on 06.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

enum PhotoResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    private let session: URLSession = { return URLSession(configuration: .default) }()
    
    func fetchInterestingPhotos(completion: @escaping (PhotoResult) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processPhotoRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func processPhotoRequest(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photo(fromJSON: jsonData)
    }
    
}
