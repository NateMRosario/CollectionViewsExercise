//
//  MovieReview.swift
//  CollectionViews-Exercise
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

struct ReviewTop: Codable {
    let results: [Critic]
}
struct Critic: Codable {
    let name: String
    let multimedia: ResourceWrapper?
    enum CodingKeys: String, CodingKey {
        case name = "display_name"
        case multimedia
    }
    
    struct ResourceWrapper: Codable {
        let resource: ImageWrapper?
        
        struct ImageWrapper: Codable {
            let image: String?
            enum CodingKeys: String, CodingKey {
                case image = "src"
            }
        }
    }
}

struct CriticAPIClient {
    private init() {}
    static let manager = CriticAPIClient()
    private let urlStr = "https://api.nytimes.com/svc/movies/v2/critics/all.json?api-key=ef6e801396e44409a1b28aee9dbcd7d4"
    func getCritic( completionHandler: @escaping ([Critic]) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoCritic: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(ReviewTop.self, from: data)
                let critic = results.results
                completionHandler(critic)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCritic, errorHandler: errorHandler)
    }
}

