//
//  Image+Extension.swift
//  ProjectRubberDucky
//
//  Created by Ruan Jansen on 2024/07/06.
//

import Foundation
import SwiftUI

//extension Image {
//    init?(data: Data) {
//        guard let image = UIImage(data: data) else { return nil }
//        self = .init(uiImage: image)
//    }
//
//    init?(url: URL?, headers: [String: String]? = nil, placeholderImage: Image? = nil) {
//        var displayImage: Image = .init(systemName: "wifi.slash")
//        self.init(systemName: "wifi.slash")
//
//        let config = URLSessionConfiguration.default
//
//        if let headers {
//            config.httpAdditionalHeaders = headers
//        }
//
//        // Create a custom URLSession with the configuration
//        let session = URLSession(configuration: config)
//
//        // Create a URLRequest with the custom session
//
//        guard let url else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        // Load the image with the URLRequest
//        session.dataTask(with: request) { data, response, error in
//            // Handle response if needed
//            if let data {
//                if let image = UIImage(data: data) {
//                    displayImage = .init(uiImage: image)
//                } else {
//                    if let placeholderImage {
//                        displayImage = placeholderImage
//                    }
//                }
//            }
//        }
//        .resume()
//
//        self = displayImage
//    }
//
//    func fetchPlexImage(url: URL?) -> Image {
//        var result: Image?
//        let headers = ["X-Plex-Token": PlexAuthentication.primaryTokenRuanPc]
//
//        // Create a custom URLSessionConfiguration
//        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = headers
//
//        // Create a custom URLSession with the configuration
//        let session = URLSession(configuration: config)
//
//        // Create a URLRequest with the custom session
//        if let imageUrl = url {
//            var request = URLRequest(url: imageUrl)
//            request.httpMethod = "GET"
//
//            // Load the image with the URLRequest
//            session.dataTask(with: request) { data, response, error in
//                // Handle response if needed
//                if let data {
//                    if let image = UIImage(data: data) {
//                        result = Image(uiImage: image)
//                    } else {
//                        dump(data)
//                    }
//                }
//            }
//            .resume()
//        }
//
//        return result ?? Image(systemName: "wifi.slash")
//    }
//}
