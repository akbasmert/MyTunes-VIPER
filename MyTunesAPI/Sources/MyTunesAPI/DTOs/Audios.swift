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
    public let wrapperType: String?
    public let kind: String?
    public let collectionID, trackID: Int?
    public let artistName, collectionName, trackName, collectionCensoredName: String?
    public let trackCensoredName: String?
    public let collectionArtistID: Int?
    public let collectionArtistViewURL, collectionViewURL, trackViewURL: String?
    public let previewURL: String?
    public let artworkUrl30, artworkUrl60, artworkUrl100: String?
    public let collectionPrice, trackPrice, trackRentalPrice, collectionHDPrice: Double?
    public let trackHDPrice, trackHDRentalPrice: Double?
    public let releaseDate: Date?
    public let collectionExplicitness, trackExplicitness: String?
    public let discCount, discNumber, trackCount, trackNumber: Int?
    public let trackTimeMillis: Int?
    public let country: String?
    public let currency: String?
    public let primaryGenreName, contentAdvisoryRating, shortDescription, longDescription: String?
    public let hasITunesExtras: Bool?
    public let artistID: Int?
    public let artistViewURL: String?
    public let isStreamable: Bool?
    public let collectionArtistName: String?

    public enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case collectionID
        case trackID
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case collectionArtistID
        case collectionArtistViewURL
        case collectionViewURL
        case trackViewURL
        case previewURL
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, trackRentalPrice
        case collectionHDPrice
        case trackHDPrice
        case trackHDRentalPrice
        case releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, shortDescription, longDescription, hasITunesExtras
        case artistID
        case artistViewURL
        case isStreamable, collectionArtistName
    }
}
