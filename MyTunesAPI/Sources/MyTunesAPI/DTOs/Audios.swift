//
//  Audios.swift
//  
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import Foundation

// MARK: - AudioResult
public struct AudioResult: Decodable {
    public let resultCount: Int?
    public let results: [Audio]?
}

// MARK: - Result
public struct Audio: Decodable {
    public let trackId: Int?
    public let artistName, trackName: String?
    public let previewUrl: String?
    public let artworkUrl100: String?

    public enum CodingKeys: String, CodingKey {
        case trackId
        case artistName, trackName
        case previewUrl
        case artworkUrl100
    }
}
