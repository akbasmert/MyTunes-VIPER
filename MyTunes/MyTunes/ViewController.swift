//
//  ViewController.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit
import MyTunesAPI


class ViewController: UIViewController {
    
    let service: AudiosServiceProtocol = AudiosService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchAudios()
    }

    fileprivate func fetchAudios() {
        // TODO: Show loading indicator puan için önemli
        service.fetchAudios(key: "") { [weak self] response in
            guard self != nil else { return }
            // TODO: hide loading
            switch response {
            case .success(let movies):
               print("Mert: \(movies)")
               
                // TODO: collectionview reload data
            case .failure(let error):
                print("Mert: \(error)")
            }
        }
    }
    
}

