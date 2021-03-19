//
//  ApiClient.swift
//  NasaAlbumIOS
//
//  Created by Iryna Betancourt on 3/15/21.
//

import UIKit

class ApiClient {
    
    // singleton created to use it for api services calls throughout the app
    static let shared = ApiClient()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    // get data for images from api per page
    func getImages(page: Int, completion: @escaping (Result<NasaCollection?, CustomError>) -> Void) {
        let endpoint = ApiEndpoint.fetchImages(page: page).url
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            
            if let _ = error {
                completion(.failure(.badRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidServerResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.notFound))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let imagesCollection = try decoder.decode(NasaCollection.self, from: data)
                completion(.success(imagesCollection))
            } catch _ {
                completion(.failure(.parsingError))
            }
        }
        
        task.resume()
    }
    
    // download image itself and use it for presenting on UI
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        
        task.resume()
    }
}
