//
//  HomeViewController.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func setupTableView()
    func reloadData()
    func showError(_ message: String)
    func showLoadingView()
    func hideLoadingView()
    func setTitle(_ title: String)
}

final class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: HomePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
       
        
    }
}


extension HomeViewController: HomeViewControllerProtocol {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.register(cellType: NewsCell.self)
       // tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
    func showError(_ message: String) {
        showAlert("Error", message)
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems()
      
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
        
       
         if let audios = presenter.audios(indexPath.row) {
             cell.cellPresenter = HomeCellPresenter(view: cell, audios: audios)
             print(audios)
             print("********")
         }
        
        
         cell.selectionStyle = .none
        
        return cell
    }

    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
