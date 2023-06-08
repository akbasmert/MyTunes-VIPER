//
//  HomeRouter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import Foundation

protocol HomeRouterProtocol {
    func navigate(_ route: HomeRoutes)
}

enum HomeRoutes {
    case detail(audioURL: String?,
                audioTitle: String?,
                audioArtistName: String?,
                audioImageURL: String?
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
                     let audioImageURL
        ):
            
            let detailVC = DetailRouter.createModule()
            detailVC.audioURL = audioURL
            detailVC.audioTitle = audioTitle
            detailVC.audioArtistName = audioArtistName
            detailVC.adudioImageURL = audioImageURL
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
            
   
        }
    }
}
