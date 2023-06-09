//
//  HomeRouter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import Foundation
//import UIKit

protocol HomeRouterProtocol {
    func navigate(_ route: HomeRoutes)
}

enum HomeRoutes {
    case detail(audioURL: String?,
                audioTitle: String?,
                audioArtistName: String?,
                audioImageURL: String?,
                audioTrackId: Int?
    )
}

final class HomeRouter {
    
    weak var viewController: HomeViewController?
    
    static func createModule() -> HomeViewController {
         let view = HomeViewController()
        let interactor = HomeInteractor()
         let router = HomeRouter()
         let presenter = HomePresenter(view: view, router: router, interactor: interactor)
         view.presenter = presenter
         interactor.output = presenter
         router.viewController = view
         return view
     }
    
}

extension HomeRouter: HomeRouterProtocol {
    
    func navigate(_ route: HomeRoutes) {
        
        switch route {
        case .detail(let audioURL,
                     let audioTitle,
                     let audioArtistName,
                     let audioImageURL,
                     let audioTrackId
        ):
            
            let detailVC = DetailRouter.createModule()
            detailVC.audioURL = audioURL
            detailVC.audioTitle = audioTitle
            detailVC.audioArtistName = audioArtistName
            detailVC.audioImageURL = audioImageURL
            detailVC.audioTrackId = audioTrackId
           // viewController?.navigationController?.pushViewController(detailVC, animated: true)
            
//            if let navigationController = viewController?.navigationController {
//                detailVC.modalPresentationStyle = .fullScreen
//                navigationController.present(detailVC, animated: true)
//            }

//            if let navigationController = viewController?.navigationController {
//                detailVC.modalPresentationStyle = .overFullScreen
//                navigationController.present(detailVC, animated: false) {
//                    detailVC.view.alpha = 0.0
//                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//                        detailVC.view.alpha = 1.0
//                    }, completion: nil)
//                }
//            }
            
            // Popup olarak sayfayı açma işlemi
//            if (viewController?.navigationController) != nil {
//                detailVC.modalPresentationStyle = .overCurrentContext
//                detailVC.modalTransitionStyle = .coverVertical
//               // detailVC.view.backgroundColor = UIColor.clear
//                viewController?.present(detailVC, animated: true, completion: nil)
//            }

            if let navigationController = viewController?.navigationController {
                detailVC.modalPresentationStyle = .overCurrentContext
                navigationController.present(detailVC, animated: true, completion: nil)
            }



        }
    }
}
