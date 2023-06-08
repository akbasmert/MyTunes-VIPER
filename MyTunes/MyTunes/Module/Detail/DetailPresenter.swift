//
//  DetailPresenter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import UIKit
import MyTunesAPI
import AVFoundation

protocol DetailPresenterProtocol {
    func viewDidLoad()
    func tapSeeMore()
}

extension DetailPresenter {
    fileprivate enum Constants {
        static let pageTitle: String = "Detail"
    }
}

final class DetailPresenter {
    
    unowned var view: DetailViewControllerProtocol!
    let router: DetailRouterProtocol!
    var audioPlayer: AVAudioPlayer?

    
    
    init(
        view: DetailViewControllerProtocol,
        router: DetailRouterProtocol
    ) {
        self.view = view
        self.router = router
    }
    
   
    
}

extension DetailPresenter: DetailPresenterProtocol {
    func tapSeeMore() {
        
    }
    
    
    func viewDidLoad() {
    
      //  guard let news = view.getSource() else { return }
       
        print(view.getAudioURL())
        print("****** \(view.getAudioTitle()) *********")
        print("****** \(view.getAudioArtistNmae()) *********")
        print("****** \(view.getAudioImageURL()) *********")
        playAudio(for: view.getAudioURL())
    }
    
   
    func fetchAudio(for urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
            guard let audioURL = URL(string: urlString) else {
                let error = NSError(domain: "not URL", code: 0, userInfo: nil)
                completion(.failure(error))
                return
                }
            
            let session = URLSession.shared
            let task = session.dataTask(with: audioURL) { (data, response, error) in
                if let error = error {
                completion(.failure(error))
                return
                }
                
            guard let audioData = data else {
                let error = NSError(domain: "Data Error", code: 0, userInfo: nil)
                completion(.failure(error))
                return
                }
                completion(.success(audioData))
            }
            task.resume()
        }
    

    func playAudio(for urlString: String) {
        fetchAudio(for: urlString) { [weak self] result in
            switch result {
            case .success(let audioData):
                DispatchQueue.main.async {
                    do {
                        self?.audioPlayer = try AVAudioPlayer(data: audioData)
                        self?.audioPlayer?.prepareToPlay()
                        self?.audioPlayer?.play()
                    } catch {
                        print("Audio player error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Audio data fetch error: \(error.localizedDescription)")
            }
        }
    }
    
}

