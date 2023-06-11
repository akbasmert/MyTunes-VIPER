//
//  SplashViewController.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
}

final class SplashViewController: BaseViewController {

    var presenter: SplashPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidAppear()
    }

}

extension SplashViewController: SplashViewControllerProtocol {
    
    func noInternetConnection() {
        DispatchQueue.main.async {
            self.showAlert("Error", "No internet")
        }
    }
    
}
