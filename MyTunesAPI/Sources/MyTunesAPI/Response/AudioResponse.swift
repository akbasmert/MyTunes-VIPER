//
//  AudioResponse.swift
//  
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import Foundation

public struct AudioResponse: Decodable {
    public let results: [Audio]
    
    private enum RootCodingKeys: String, CodingKey {
        case results
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        self.results = try container.decode([Audio].self, forKey: .results)
    }
}
