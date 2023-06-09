//
//  HomeInteractor.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import MyTunesAPI

typealias AudioResult = Result<[Audio], Error>

protocol HomeInteractorProtocol: AnyObject {
    func fetchAudios(key: String, filerKey: String)
}

protocol HomeInteractorOutputProtocol {
    func fetchAudioOutput(_ result: AudioResult)
}

fileprivate var service: AudiosServiceProtocol = AudiosService()


final class HomeInteractor {
    var output: HomeInteractorOutputProtocol?
}

extension HomeInteractor: HomeInteractorProtocol {
    
    func fetchAudios(key: String, filerKey: String) {
        service.fetchAudios(key: key, filterKey: filerKey) { [weak self] result in
            guard let self else { return }
            self.output?.fetchAudioOutput(result)
            
        }
    }
}
