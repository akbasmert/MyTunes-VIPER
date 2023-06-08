//
//  DetailInteractor.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import Foundation

//Detay sayfasında veri çekilmeyecekse bu protocol tanımlanmayabilir
protocol DetailInteractorProtocol {
    
}

protocol DetailInteractorOutputProtocol {
    func fetchNewsDetailOutput(result: AudioResult)
}


final class DetailInteractor {
    var output: HomeInteractorOutputProtocol?
}
