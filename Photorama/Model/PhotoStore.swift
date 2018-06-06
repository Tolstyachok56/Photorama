//
//  PhotoStore.swift
//  Photorama
//
//  Created by Виктория Бадисова on 06.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class PhotoStore {
    
    private let session: URLSession = { return URLSession(configuration: .default) }()
    
    func fetchInterestingPhotos() {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(jsonObject)
                } catch let error{
                    print("Error creating JSON object: \(error)")
                }
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
    
}
