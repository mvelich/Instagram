//
//  InstagramResponseParser.swift
//  InstagrammPhoto
//
//  Created by Maksim Velich on 11/19/20.
//  Copyright © 2020 Maksim Velich. All rights reserved.
//

import Foundation
import Alamofire

class InstagramResponseParser {
    
    func getInstagrammResponse(userNickName: String) {
        AF.request("https://www.instagram.com/\(userNickName)/?__a=1").responseJSON { response in
            guard let responseData = response.data else { return }
            switch (response.result) {
            case .success( _):
                do {
                    let json = try JSONDecoder().decode(RawServerResponse.Root.self, from: responseData)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            }
        }
    }
}

fileprivate struct RawServerResponse: Decodable {
    struct Root: Decodable {
        var graphql: Graphql?
    }
    
    struct Graphql: Decodable {
        var user: UserSelf?
    }
    
    struct UserSelf: Decodable {
        var edgeOwner: EdgeOwner?
        
        enum CodingKeys: String, CodingKey {
            case edgeOwner = "edge_owner_to_timeline_media"
        }
    }
    
    struct EdgeOwner: Decodable {
        var edges: [Edges]?
    }
    
    struct Edges: Decodable {
        var node: Node?
    }
    
    struct Node: Decodable {
        var displayUrl: String?
        var location: LocationName?
        
        enum CodingKeys: String, CodingKey {
            case displayUrl = "display_url"
        }
    }
    
    struct LocationName: Decodable {
        var name: String?
    }
}

