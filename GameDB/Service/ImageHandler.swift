//
//  ImageDownloader.swift
//  GameDB
//
//  Created by Hada Melino on 17/05/23.
//

import Foundation
import UIKit

var gameListCache = NSCache<NSURL,UIImage>()
var detailGameCache = NSCache<NSURL, UIImage>()

class ImageHandler {
    
    private var task: URLSessionTask?    
    
    func imageDownloader(url: String, downSampleTo: CGSize, cache: NSCache<NSURL, UIImage>, completion: @escaping (UIImage?) -> ()) {
        guard let imageURL = URL(string: url) else { return }
        if let cachedImage = cache.object(forKey: imageURL as NSURL) {
            completion(cachedImage)
            return
        }
        task = URLSession.shared.dataTask(with: imageURL, completionHandler: { data, response, err in
            if err != nil {
                completion(nil)
                print(err?.localizedDescription, imageURL)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let downsampledImage = try self.downsample(imageData: data, to: downSampleTo, scale: 1)
                cache.setObject(downsampledImage, forKey: imageURL as NSURL)
                completion(downsampledImage)
            } catch {
                print(error)
            }
            
        })
        
        task?.resume()
    }

    func cancelImageRequest() {
        task?.cancel()
    }
}

extension ImageHandler {
    
    enum DownsamplingError: Error {
        case unableToCreateData
        case unableToCreateImageSource
        case unableToCreateThumbnail
    }
    
    public func downsample(imageData: Data, to frameSize: CGSize, scale: CGFloat) throws -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary

        return try imageData.withUnsafeBytes{ (unsafeRawBufferPointer: UnsafeRawBufferPointer) -> UIImage in
            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)
            guard let unsafePointer = unsafeBufferPointer.baseAddress else {throw DownsamplingError.unableToCreateData}

            let dataPtr = CFDataCreate(kCFAllocatorDefault, unsafePointer, imageData.count)
            guard let data = dataPtr else { throw DownsamplingError.unableToCreateData }
            guard let imageSource = CGImageSourceCreateWithData(data, imageSourceOptions) else { throw DownsamplingError.unableToCreateImageSource }

            return try createThumbnail(from: imageSource, size: frameSize, scale: scale)
        }
    }

    private func createThumbnail(from imageSource: CGImageSource, size: CGSize, scale:CGFloat) throws -> UIImage {
        let maxDimensionInPixels = max(size.width, size.height) * scale
        let options = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else { throw DownsamplingError.unableToCreateThumbnail }
        return UIImage(cgImage: thumbnail)
    }
}
