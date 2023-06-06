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
}

public class AudiosService: AudiosServiceProtocol {
    public init() {}
    
    public func fetchAudios(key: String, completion: @escaping (Result<[Audio], Error>) -> Void) {
        let urlString = "https://itunes.apple.com/search?term=jack+johnson"
        AF.request(urlString).responseData { response in
            switch response.result {
            case.success(let data):
                let decoder = Decoders.dateDecoder
                
                do {
                    let response = try decoder.decode(AudioResponse.self, from: data)
                  //  competion(.success(response.results))
                    completion(.success(response.results))
                } catch {
                    print("********JSON DECODE ERROR**********\(error.localizedDescription)")
                }
            case.failure(let error):
                print("********* GEÇİÇİ BİR HATA OLUŞTU \(error.localizedDescription) ***********")
                
            }
        }
    }
}
