//
//  SearchCollectionViewCellPresenter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 8.06.2023.
//

import Foundation

protocol SearchCollectionViewCellPresenterProtocol: AnyObject {
    func load()
}

final class SearchCollectionViewCellPresenter {
    
    weak var view: SearchCollectionViewCellProtocol?
    private let title: String
    
    init(
        view: SearchCollectionViewCellProtocol?,
         title: String
    ){
        self.view = view
        self.title = title
    }
}

extension SearchCollectionViewCellPresenter: SearchCollectionViewCellPresenterProtocol {
   
    func load() {
        view?.setTitle(title)
    }
}
