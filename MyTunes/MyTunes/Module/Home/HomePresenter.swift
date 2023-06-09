//
//  HomePresenter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import MyTunesAPI

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfItems() -> Int
    func titleNumberOfItems() -> Int
    func titleString(index: Int) -> String?
    func audios(_ index: Int) -> Audio?
    func title(_ index: Int) -> String?
    func didSelectRowAt(index: Int)
    func titleDidSelectRowAt(index: Int)
    func fetchAudios(key: String, filterKey: String)
    func setSearchKey(searchKey: String)
    
    var getFilterKey: String { get }
    var searchKey: String { get }
}

final class HomePresenter {
   
    unowned var view: HomeViewControllerProtocol
    let router: HomeRouterProtocol!
    let interactor: HomeInteractorProtocol!
    
    var filterKey: String = ""
    var searchSetKey: String = ""
    
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
   
    
    var searchKey: String {
       searchSetKey
    }
    
    var getFilterKey: String {
        return filterKey
    }
    
    func setSearchKey(searchKey: String) {
        self.searchSetKey = searchKey
    }
    
    func sendData(audio: Audio) {}
    
    func viewDidLoad() {
        view.setupSearchTableView()
        view.setupTableView()
        view.setTitle("NYTimes Top News")
        fetchAudios(key: "Tarkan", filterKey: "")
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
                                audioImageURL: source.artworkUrl100, audioTrackId: source.trackId
                               ))
        print("tılandı")
        
    }
    
    func titleDidSelectRowAt(index: Int) {

        switch index {
        case 0:
            filterKey = ""
        case 1:
            filterKey = "song"
        case 2:
            filterKey = "musicVideo"
        case 3:
            filterKey = "podcast"
        case 4:
            filterKey = "movie"
        case 5:
            filterKey = "ebook"
        default:
            filterKey = "tvEpisode"
        }
    }
    
    func fetchAudios(key: String, filterKey: String) {
        view.showLoadingView()
        interactor.fetchAudios(key: key, filerKey: filterKey)
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


