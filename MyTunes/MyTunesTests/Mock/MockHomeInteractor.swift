//
//  MockHomeInteractor.swift
//  MyTunesTests
//
//  Created by Mert AKBAŞ on 12.06.2023.
//

import Foundation
@testable import MyTunes

final class MockHomeInteractor: HomeInteractorProtocol {
    
    var isInvokedFetchAudios = false
    var inkovedFetchAudiosCount = 0
    
    func fetchAudios(key: String, filerKey: String) {
        isInvokedFetchAudios = true
        inkovedFetchAudiosCount += 1
    }
}
