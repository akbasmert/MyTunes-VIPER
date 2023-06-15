//
//  HomePresenterTests.swift
//  MyTunesTests
//
//  Created by Mert AKBAŞ on 12.06.2023.
//

import XCTest
@testable import MyTunes
@testable import MyTunesAPI

final class HomePresenterTests: XCTestCase {
    
    var presenter: HomePresenter!
    var view: MockHomeViewController!
    var interactor: MockHomeInteractor!
    var router: MockHomeRouter!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        router = .init()
        presenter = .init(view: view, router: router, interactor: interactor)
    }
    
    override func tearDown() {
        view = nil
        interactor = nil
        router = nil
        presenter = nil
    }

    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.isInvokedSetupTableView)
        XCTAssertFalse(view.isInvokedSetupSearchTableView)
        XCTAssertEqual(view.invokedSetupTableViewCount, 0)
        XCTAssertEqual(view.invokedSetupSearchTableViewCount, 0)
        XCTAssertFalse(view.isInvokedSetTitle)
        XCTAssertNil(view.invokedSetTitleParameters)
        XCTAssertFalse(interactor.isInvokedFetchAudios)
        XCTAssertEqual(interactor.inkovedFetchAudiosCount, 0)
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(view.isInvokedSetupTableView)
        XCTAssertTrue(view.isInvokedSetupSearchTableView)
        XCTAssertEqual(view.invokedSetupTableViewCount, 1)
        XCTAssertEqual(view.invokedSetupSearchTableViewCount, 1)
        XCTAssertTrue(view.isInvokedSetTitle)
        XCTAssertEqual(view.invokedSetTitleParameters?.title, "My Tunes")
        XCTAssertTrue(interactor.isInvokedFetchAudios)
        XCTAssertEqual(interactor.inkovedFetchAudiosCount, 1)
        
    }
    
    func test_fetchAudiosOutput() {
        XCTAssertFalse(view.isInvokedHideLoading)
        XCTAssertFalse(view.isInvokedReloadData)
        
        presenter.fetchAudioOutput(.success([Audio.response]))

        XCTAssertTrue(view.isInvokedHideLoading)
        XCTAssertTrue(view.isInvokedReloadData)
    }
}

extension Audio {
    static var response: Audio {
        let bundle = Bundle(for: HomePresenterTests.self)
        let path = bundle.path(forResource: "Audios", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)!
        let decoder = Decoders.dateDecoder
        let response = try! decoder.decode(Audio.self, from: data)
        return response
    }
}
