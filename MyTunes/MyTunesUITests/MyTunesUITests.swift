//
//  MyTunesUITests.swift
//  MyTunesUITests
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import XCTest

final class MyTunesUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("******** UITest ********")
    }
    
    func test_navigate_Detail_to_Home_controller() {
  
        app.launch()
        sleep(1)
        
        XCTAssertTrue(app.isSearchBarDisplayed)
        XCTAssertTrue(app.isTableViewDisplayed)
        
        app.searchBar.tap()
        app.searchBar.typeText("Duman")

        XCTAssertTrue(app.isSearchTableViewDisplayed)
        XCTAssertTrue(app.isSearchCollectionViewDisplayed)

        let firstCell = app.searchTableView.cells.element(boundBy: 0)
        firstCell.tap()
   
        sleep(1)
        
        XCTAssertTrue(app.isAudioTitleLabelDisplayed)
        XCTAssertTrue(app.isAudioArtistNameLabel)
        XCTAssertTrue(app.isAudioImageViewDisplayed)
    }
}

extension XCUIApplication {
   
    var searchBar: XCUIElement! {
        otherElements["searchBar"]
    }
    
    var tableView: XCUIElement! {
        tables["tableView"]
    }
    
    var searchTableView: XCUIElement! {
        tables["searchTableView"]
    }
    
    var searchCollectionView: XCUIElement! {
        collectionViews["searchCollectionView"]
    }
    
    var audioImageView: XCUIElement! {
        images.matching(identifier: "audioImageView").element
    }

    var audioTitleLabel: XCUIElement! {
        staticTexts.matching(identifier: "audioTitleLabel").element
    }
    
    var audioArtistNameLabel: XCUIElement! {
        staticTexts.matching(identifier: "audioArtistNameLabel").element
    }
    
    var isAudioImageViewDisplayed: Bool {
        audioImageView.exists
    }
    
    var isAudioArtistNameLabel: Bool {
        audioArtistNameLabel.exists
    }
    
    var isAudioTitleLabelDisplayed: Bool {
        audioTitleLabel.exists
        
    }
    
    var isSearchBarDisplayed: Bool {
        searchBar.exists
    }
    
    var isTableViewDisplayed: Bool {
        tableView.exists
    }
    
    var isSearchTableViewDisplayed: Bool {
        searchTableView.exists
    }
    
    var isSearchCollectionViewDisplayed: Bool {
        searchCollectionView.exists
    }
}

