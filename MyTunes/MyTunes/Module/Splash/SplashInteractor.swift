//
//  SplashInteractor.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import Foundation
import MyTunesAPI

protocol SplashInteractorProtocol {
    func checkInternetConnection()
}

protocol SplashInteractorOutputProtocol {
    func internetConnection(status: Bool)
}

final class SplashInteractor {
    
    private let service: AudiosServiceProtocol
    
    var output: SplashInteractorOutputProtocol?
    
    init(service: AudiosServiceProtocol = AudiosService()) {
        self.service = service
    }
}

extension SplashInteractor: SplashInteractorProtocol {
    
    func checkInternetConnection() {
       // let internetStatus = API.shared.isConnectedToInternet()
        let internetStatus = service.isConnectedToInternet()
        self.output?.internetConnection(status: internetStatus)
    }
   
}
