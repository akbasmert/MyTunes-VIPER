//
//  MockHomeRouter.swift
//  MyTunesTests
//
//  Created by Mert AKBAŞ on 12.06.2023.
//

import Foundation
@testable import MyTunes

final class MockHomeRouter: HomeRouterProtocol {
    
    var isInvokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (route: HomeRoutes, Void)?
    
    func navigate(_ route: MyTunes.HomeRoutes) {
        isInvokedNavigate = true
        invokedNavigateCount += 1
        invokedNavigateParameters = (route, ())
    }
}

