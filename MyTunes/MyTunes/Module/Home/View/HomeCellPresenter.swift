//
//  HomeCellPresenter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit
import MyTunesAPI

protocol HomeCellPresenterProtocol: AnyObject {
    func load()
}

final class HomeCellPresenter {
    
    weak var view: HomeCellProtocol?
    private let audios: Audio
    
    init(
        view: HomeCellProtocol?,
         audios: Audio
    ){
        self.view = view
        self.audios = audios
    }
}

extension HomeCellPresenter: HomeCellPresenterProtocol {
   
    func load() {
        
        ImageDownloader.shared.image(news: audios) { [weak self] data, error in
            guard let self = self else { return }
            
            if let data = data {
                if let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.view?.setImage(img)
                    }
                }
            }
        }

        
        view?.setTitle(audios.trackName ?? "")
        view?.setAuthor(audios.artistName ?? "")
        
    }
    
}
