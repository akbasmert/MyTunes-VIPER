//
//  DetailInteractor.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import Foundation
import AVFAudio

protocol DetailInteractorProtocol {
    func fetchAudioData() -> [Int]
    func deleteAudioData(trackId: Int)
    func saveAudioData(trackId: Int)
    func playAudio(for urlString: String)
    func stopAudio()
}

final class DetailInteractor {

    var audioPlayer: AVAudioPlayer?

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

extension DetailInteractor: DetailInteractorProtocol {
    
    func stopAudio() {
        audioPlayer?.stop()
    }
    
    func fetchAudioData() -> [Int] {
        let favoriTrackIds = CoreDataManager.shared.fetchAudioData()
        return favoriTrackIds
    }
    
    func deleteAudioData(trackId: Int) {
        CoreDataManager.shared.deleteAudioData(withTrackId: trackId)
    }
    
    func saveAudioData(trackId: Int) {
        CoreDataManager.shared.saveAudioData(Int64(trackId))
    }
    
    func playAudio(for urlString: String) {
        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                audioPlayer.pause()
            } else {
                audioPlayer.play()
            }
        } else {
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
}

