//
//  DetailRouter.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import Foundation

protocol DetailRouterProtocol {
    func navigate(_ route: DetailRoutes)
}

enum DetailRoutes {
    case openURL(url: URL)
}

final class DetailRouter {
    
    weak var viewController: DetailViewController?
    
    static func createModule() -> DetailViewController {
         let view = DetailViewController()
         let router = DetailRouter()
         let interactor = DetailInteractor()
        
         let presenter = DetailPresenter(view: view, router: router, interactor: interactor)
         view.presenter = presenter
         router.viewController = view
         return view
     }
    
}

extension DetailRouter: DetailRouterProtocol {
    
    func navigate(_ route: DetailRoutes) {
        
//        switch route {
//        case .openURL(let url):
//            let urlForNews = SFSafariViewController(url: url)
//            viewController?.present(urlForNews, animated: true)
//        }
        
    }
    
}
