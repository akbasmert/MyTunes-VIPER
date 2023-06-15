//
//  HomeViewController.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit
import NotificationCenter

protocol HomeViewControllerProtocol: AnyObject {
   
    func setupSearchTableView()
    func setupTableView()
    func setupSearchCollectionView()
    func reloadData()
    func searchReloadData()
    func showError(_ message: String)
    func showLoadingView()
    func hideLoadingView()
    func setTitle(_ title: String)
}

final class HomeViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchTableView: UITableView!
    
    var presenter: HomePresenterProtocol!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
       
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(playButtonTapped(_:)), name: NSNotification.Name("PlayButtonTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNextIndexSelected(_:)), name: Notification.Name("NextIndexSelected"), object: nil)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        
         setAccessiblityIdentifiers() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    
    @objc func handleNextIndexSelected(_ notification: Notification) {
        if let nextIndex = notification.object as? Int {
            presenter.didSelectRowAt(index: nextIndex)
        }
    }
    
    @objc func playButtonTapped(_ notification: Notification) {
            tableView.reloadData()
       
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    
    func setupSearchCollectionView() {
        searchCollectionView.register(SearchCollectionViewCell.self,
                                      forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.reloadData()
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        searchCollectionView.selectItem(at: firstIndexPath,
                                        animated: true, scrollPosition: .left)
    }
    
    func setupSearchTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(EmptyTableViewCell.self,
                                 forCellReuseIdentifier: "EmptyCell")
        searchTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EmptyTableViewCell.self,
                           forCellReuseIdentifier: "EmptyCell")
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil),
                           forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
    func searchReloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.searchTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {

        if tableView == self.tableView {
            return "Sizin için"
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if presenter.numberOfItems() == 0 {
           
            return 1
        } else {
            if tableView == self.tableView {
               return presenter.numberOfItems()
            }
            return presenter.numberOfItems()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == self.tableView {
          
            if presenter.numberOfItems() == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyTableViewCell
                emptyCell.selectionStyle = .none
                return emptyCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
             
                if let audios = presenter.audios(indexPath.row) {
                   
                    cell.cellPresenter = HomeCellPresenter(view: cell, audios: audios)
                }
                cell.selectionStyle = .none
                
                // burası
                cell.playingIndexPath = indexPath.row
               return cell
            }
        } else {
            if presenter.numberOfItems() == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyTableViewCell
                emptyCell.selectionStyle = .none
                return emptyCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
               
                if let audios = presenter.audios(indexPath.row) {
                    
                    cell.cellPresenter = HomeCellPresenter(view: cell, audios: audios)
                }
                cell.selectionStyle = .none
                // burası
                cell.playingIndexPath = indexPath.row
               return cell
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if presenter.numberOfItems() == 0 {
        } else {
            if tableView == self.tableView {
                presenter.didSelectRowAt(index: indexPath.row)
                
            } else {
                presenter.didSelectRowAt(index: indexPath.row)
            }
            tableView.reloadData()
        }
        
        HomeCellPresenter.cellAudioPlayer?.stop()
        HomeCellPresenter.cellAudioPlayer = nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if presenter.numberOfItems() == 0 {
            return tableView.frame.size.height
        } else {
            return 80
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.titleNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchCollectionViewCell
        
        if let title = presenter.title(indexPath.row) {
            cell.cellPresenter = SearchCollectionViewCellPresenter(view: cell, title: title)
        }
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        if searchTableView.numberOfRows(inSection: 0) > 0 {
            let indexPathTableView = IndexPath(row: 0, section: 0)
            searchTableView.scrollToRow(at: indexPathTableView, at: .top, animated: true)
        }
        presenter.titleDidSelectRowAt(index: indexPath.row)
        print(presenter.searchKey)
        print(presenter.getFilterKey)
        self.presenter.fetchAudios(key: presenter.searchKey, filterKey: presenter.getFilterKey)
            tableView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let label = UILabel()
            label.text = presenter.titleString(index: indexPath.row)
            label.sizeToFit()
            let width = label.frame.width + 24
        
         return CGSize(width: width, height: 30)
     }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        uiView.isHidden = false
        if !searchText.isEmpty {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.presenter.fetchAudios(key: searchText, filterKey: self?.presenter.getFilterKey ?? "")
                self?.presenter.setSearchKey(searchKey: searchText)
                self?.tableView.reloadData()
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        uiView.isHidden = true
          searchBar.showsCancelButton = false
          searchBar.text = nil
          searchBar.resignFirstResponder()
          presenter.viewDidLoad()
        let firstIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .top)
      }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        let firstIndexPath = IndexPath(item: 0, section: 0)
        searchCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .left)
          return true
      }
}

extension HomeViewController {
    func setAccessiblityIdentifiers() {
        searchBar.accessibilityIdentifier = "searchBar"
        tableView.accessibilityIdentifier = "tableView"
        searchTableView.accessibilityIdentifier = "searchTableView"
        searchCollectionView.accessibilityIdentifier = "searchCollectionView"
    }
}
