//
//  HomePresenter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import Foundation
import MyTunesAPI

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfItems() -> Int
    func titleNumberOfItems() -> Int
    func titleString(index: Int) -> String?
    func audios(_ index: Int) -> Audio?
    func title(_ index: Int) -> String?
    func didSelectRowAt(index: Int)
    func fetchAudios(key: String)
}

final class HomePresenter {
   
    unowned var view: HomeViewControllerProtocol
    let router: HomeRouterProtocol!
    let interactor: HomeInteractorProtocol!
    
    private var audios: [Audio] = []
    var searchHeader: [String] = ["all", "music", "musicVideo", "podcast", "movie", "ebook", "tvShow"]
    
    init(
         view: HomeViewControllerProtocol,
         router: HomeRouterProtocol,
         interactor: HomeInteractorProtocol)
    {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
}

extension HomePresenter: HomePresenterProtocol {
   
    func sendData(audio: Audio) {}
    
    func viewDidLoad() {
        view.setupSearchTableView()
        view.setupTableView()
        view.setTitle("NYTimes Top News")
        fetchAudios(key: "Tarkan")
    }
    
    func numberOfItems() -> Int {
        audios.count
    }
    
    func titleNumberOfItems() -> Int {
        searchHeader.count
    }
    
    func titleString(index: Int) -> String? {
        searchHeader[index]
    }
    
    func audios(_ index: Int) -> Audio? {
        return audios[index]
    }
    
    func title(_ index: Int) -> String? {
        return searchHeader[index]
    }
    
    func didSelectRowAt(index: Int) {
        guard let source = audios(index) else { return }
        router.navigate(.detail(audioURL: source.previewUrl,
                                audioTitle: source.trackName,
                                audioArtistName: source.artistName,
                                audioImageURL: source.artworkUrl100
                               ))
        print("tılandı")
        
    }
    
    func fetchAudios(key: String) {
        view.showLoadingView()
        interactor.fetchAudios(key: key)
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
    func fetchAudioOutput(_ result: AudioResult) {
        
        view.hideLoadingView()
        
        switch result {
        case .success(let response):
            self.audios = response
           
            
            view.searchReloadData()
            view.reloadData()
        case .failure(let error):
            view.showError(error.localizedDescription)
        }
    }
}


