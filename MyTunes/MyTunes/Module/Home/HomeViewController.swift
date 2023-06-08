//
//  HomeViewController.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
   
    func setupSearchTableView()
    func setupTableView()
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

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
       
        searchBar.delegate = self
       
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.reloadData()
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        searchCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .left)
    }
    
   
}

extension HomeViewController: HomeViewControllerProtocol {
    
    func setupSearchTableView() {
        searchTableView.dataSource = self
        searchTableView.delegate = self
       // tableView.register(cellType: NewsCell.self)
       // tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        searchTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
    }
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
           return presenter.numberOfItems()
        }
        return presenter.numberOfItems()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
        
        
        if tableView == self.tableView {
          
             if let audios = presenter.audios(indexPath.row) {
                 cell.cellPresenter = HomeCellPresenter(view: cell, audios: audios)
               //  print(audios)
             }
            
            
             cell.selectionStyle = .none
            
            return cell
            
        } else {
            if let audios = presenter.audios(indexPath.row) {
                cell.cellPresenter = HomeCellPresenter(view: cell, audios: audios)
              //  print(audios)
            }
           
           
            cell.selectionStyle = .none
           
           return cell
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            presenter.didSelectRowAt(index: indexPath.row)
            
        } else {
            presenter.didSelectRowAt(index: indexPath.row)

        }
       
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
          //  print(audios)
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
         // Hücre boyutunu burada belirleyin
         
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
                
                print(self!.presenter.searchKey)
                self?.tableView.reloadData()
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          // İptal düğmesine tıklandığında yapılacak işlemleri burada gerçekleştirin
        uiView.isHidden = true
        searchBar.showsCancelButton = false

          searchBar.text = nil // Arama metnini sıfırla
          searchBar.resignFirstResponder() // Klavyeyi kapat
      }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
          // Arama çubuğuna tıklandığında yapılacak işlemleri burada gerçekleştirin
          // Örneğin, bir işlem yapmak için başka bir fonksiyonu çağırabilirsiniz
        searchBar.showsCancelButton = true


          // true döndürerek arama çubuğunun düzenlenebilir olmasını sağlayın
          return true
      }
      
}
