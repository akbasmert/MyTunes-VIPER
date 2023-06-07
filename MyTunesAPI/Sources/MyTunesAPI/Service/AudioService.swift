//
//  AudioService.swift
//  
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import Foundation
import Alamofire
import UIKit

public protocol AudiosServiceProtocol: AnyObject {
    func fetchAudios( key: String, completion: @escaping (Result<[Audio],Error>) -> Void)
    func isConnectedToInternet() -> Bool
}

public class AudiosService: AudiosServiceProtocol {
    public init() {}
    
    public func isConnectedToInternet() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    public func fetchAudios(key: String, completion: @escaping (Result<[Audio], Error>) -> Void) {
        guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // Encoding error
            return
        }
        
        let urlString = "https://itunes.apple.com/search?term=\(encodedKey)&country=tr&entity=song"
        guard let url = URL(string: urlString) else {
            // Invalid URL
            return
        }
        print(urlString)
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = Decoders.dateDecoder
                
                do {
                    let response = try decoder.decode(AudioResponse.self, from: data)
                    completion(.success(response.results))
                } catch {
                    print("********JSON DECODE ERROR**********\(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("********* GEÇİÇİ BİR HATA OLUŞTU \(error.localizedDescription) ***********")
                completion(.failure(error))
            }
        }
    }

}
