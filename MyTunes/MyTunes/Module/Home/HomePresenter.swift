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
    func audios(_ index: Int) -> Audio?
    func didSelectRowAt(index: Int)
}

final class HomePresenter {
   
    unowned var view: HomeViewControllerProtocol
    let router: HomeRouterProtocol!
    let interactor: HomeInteractorProtocol!
    
    private var audios: [Audio] = []
    
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
    
    func viewDidLoad() {
        view.setupTableView()
        view.setTitle("NYTimes Top News")
        fetchNews()
    }
    
    func numberOfItems() -> Int {
        audios.count
    }
    
    func audios(_ index: Int) -> Audio? {
        return audios[index]
    }
    
    func didSelectRowAt(index: Int) {
       // guard let source = audios(index) else { return }
       // router.navigate(.detail(source: source))
    }
    
    private func fetchNews() {
        view.showLoadingView()
        interactor.fetchAudios()
    }

}

extension HomePresenter: HomeInteractorOutputProtocol {
    
    func fetchAudioOutput(_ result: AudioResult) {
        
        view.hideLoadingView()
        
        switch result {
        case .success(let response):
            self.audios = response
         //   print(audios)
            
            view.reloadData()
        case .failure(let error):
            view.showError(error.localizedDescription)
        }
        
    }
    
}
