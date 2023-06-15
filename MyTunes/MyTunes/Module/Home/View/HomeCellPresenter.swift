//
//  HomeCellPresenter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit
import MyTunesAPI
import AVFoundation

protocol HomeCellPresenterProtocol: AnyObject {
    func load()
    func playAudio(for urlString: String)
    func stopAudio()
    func getAudioURL() -> String
}

final class HomeCellPresenter {
    
    weak var view: HomeCellProtocol?
    private let audios: Audio
    
    static var cellAudioPlayer: AVAudioPlayer?
    static var cellAudioURL: String?

    var currentAudioURL: String? // Şu anda çalınan şarkının URL'sini takip etmek için bir değişken ekleyin
    
    init(
        view: HomeCellProtocol?,
         audios: Audio
    ){
        self.view = view
        self.audios = audios
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
    
    func getAudioURL() -> String {
        audios.previewUrl ?? ""
    }

    func stopAudio() {
        HomeCellPresenter.cellAudioPlayer?.stop()
    }

    func playAudio(for urlString: String) {

        if HomeCellPresenter.cellAudioURL == urlString {
            if let audioPlayer = HomeCellPresenter.cellAudioPlayer {
                if audioPlayer.isPlaying {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play()
                }
            } else {
                fetchAudio(for: urlString) { result in
                    switch result {
                    case .success(let audioData):
                        DispatchQueue.main.async {
                            do {
                                HomeCellPresenter.cellAudioPlayer = try AVAudioPlayer(data: audioData)
                                HomeCellPresenter.cellAudioPlayer?.prepareToPlay()
                                HomeCellPresenter.cellAudioPlayer?.play()
                            } catch {
                                print("Audio player error: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        print("Audio data fetch error: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            HomeCellPresenter.cellAudioPlayer?.stop()
            HomeCellPresenter.cellAudioPlayer = nil
            if let audioPlayer = HomeCellPresenter.cellAudioPlayer {
                if audioPlayer.isPlaying {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play()
                }
            } else {
                fetchAudio(for: urlString) {  result in
                    switch result {
                    case .success(let audioData):
                        DispatchQueue.main.async {
                            do {
                                HomeCellPresenter.cellAudioPlayer = try AVAudioPlayer(data: audioData)
                                HomeCellPresenter.cellAudioPlayer?.prepareToPlay()
                                HomeCellPresenter.cellAudioPlayer?.play()
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
        HomeCellPresenter.cellAudioURL = urlString
    }
}
