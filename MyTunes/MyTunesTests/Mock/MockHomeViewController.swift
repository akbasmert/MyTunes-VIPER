//
//  MockHomeViewController.swift
//  MyTunesTests
//
//  Created by Mert AKBAŞ on 12.06.2023.
//

import Foundation
@testable import MyTunes


final class MockHomeViewController: HomeViewControllerProtocol {
    
    var isInvokedSetupSearchTableView = false
    var invokedSetupSearchTableViewCount = 0
    
    func setupSearchTableView() {
        isInvokedSetupSearchTableView = true
        invokedSetupSearchTableViewCount += 1
    }
    
    var isInvokedSetupTableView = false
    var invokedSetupTableViewCount = 0
    
    func setupTableView() {
        isInvokedSetupTableView = true
        invokedSetupTableViewCount += 1
    }
    
    
    var isInvokedReloadData = false
    var invokedReloadDataCount = 0
    
    func reloadData() {
        isInvokedReloadData = true
        invokedReloadDataCount += 1
    }
    
    var isInvokedSearchReloadData = false
    var invokedSearchReloadDataCount = 0
    
    func searchReloadData() {
        isInvokedSearchReloadData = true
        invokedSearchReloadDataCount += 1
    }
    
    var isInvokedError = false
    var invokedErrorCount = 0
    
    func showError(_ message: String) {
        isInvokedError = true
        invokedErrorCount += 1
    }
    
    var isInvokedShowLoading = false
    var invokedShowLoadingCount = 0
    
    func showLoadingView() {
        isInvokedShowLoading = true
        invokedShowLoadingCount += 1
    }
    
    var isInvokedHideLoading = false
    var invokedHideLoadingCount = 0
    
    func hideLoadingView() {
        isInvokedHideLoading = true
        invokedHideLoadingCount += 1
    }
    
    var isInvokedSetTitle = false
    var invokedSetTitleCount = 0
    var invokedSetTitleParameters: (title:String, Void)?
    
    func setTitle(_ title: String) {
        isInvokedSetTitle = true
        invokedSetTitleCount += 1
        invokedSetTitleParameters = (title, ())
    }
    
}
