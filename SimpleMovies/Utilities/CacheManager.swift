//
//  CacheManager.swift
//  SimpleMovies
//
//  Created by Abderrahman Ajid on 27/8/2024.
//

import Foundation
import UIKit

class CacheManager {
    static let shared = CacheManager()
    
    private let imageCache = NSCache<NSString, UIImage>()
    private let dataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func cacheImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }
    
    func getImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }
    
    func cacheData(_ data: Data, for key: String) {
        dataCache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func getData(for key: String) -> Data? {
        return dataCache.object(forKey: key as NSString) as Data?
    }
}
