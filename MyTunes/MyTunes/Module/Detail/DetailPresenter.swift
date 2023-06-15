//
//  DetailPresenter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import UIKit
import MyTunesAPI

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func viewDidDisappear()
    func playAudio(for urlString: String)
    func favoriButtonTapped()
    func isTrackIdSaved(_ trackId: Int) -> Bool 
}

extension DetailPresenter {
    fileprivate enum Constants {
        static let pageTitle: String = "Detail"
    }
}

final class DetailPresenter {
    
    unowned var view: DetailViewControllerProtocol!
    let router: DetailRouterProtocol!
    let interactor: DetailInteractorProtocol!
   
    init(
        view: DetailViewControllerProtocol,
        router: DetailRouterProtocol,
        interactor: DetailInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension DetailPresenter: DetailPresenterProtocol {
 
    func favoriButtonTapped() {
        let trackId = view.getTrackId()
        let favoriTrackIds = interactor.fetchAudioData()
        
        if favoriTrackIds.contains(trackId) {
            interactor.deleteAudioData(trackId: trackId)
        } else {
            interactor.saveAudioData(trackId: trackId)
        }
    }

    func isTrackIdSaved(_ trackId: Int) -> Bool {
        let favoriTrackIds = interactor.fetchAudioData()
        return favoriTrackIds.contains(trackId)
    }
  
    func viewDidLoad() {
        view.setprogressView()
        view.setTitle("")
        view.setAudioTitle(view.getAudioTitle())
        view.setAuidoArtistName(view.getAudioArtistNmae())
        imageSet()
    }
    
    func viewDidDisappear() {
        interactor.stopAudio()
    }
    
    func imageSet() {
        ImageDownloader.shared.download(imageURL: view.getAudioImageURL()) { [weak self] data, error in
            if let data = data {
                if let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.view?.setAudioImage(img)
                    }
                }
            }
        }
    }
    
    func playAudio(for urlString: String) {
        interactor.playAudio(for: urlString)
    }
}


