//
//  DetailViewController.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    func setTitle(_ title: String)
    func setNewsTitle(_ text: String)
    func setNewsDetail(_ text: String)
    func setNewsAuthor(_ text: String)
    func setNewsImage(_ image: UIImage)
    
    func getAudioURL() -> String
    func getAudioTitle() -> String
    func getAudioArtistNmae() -> String
    func getAudioImageURL() -> String
}

final class DetailViewController: BaseViewController {

    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
    var presenter: DetailPresenterProtocol!
    
   
    var audioURL: String?
    var audioTitle: String?
    var audioArtistName: String?
    var adudioImageURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
      
    }
  
}

extension DetailViewController: DetailViewControllerProtocol {
    
    func getAudioArtistNmae() -> String {
        audioArtistName ?? ""
    }
    
    func getAudioImageURL() -> String {
        adudioImageURL ?? ""
    }
    
    func getAudioTitle() -> String {
        audioTitle ?? ""
    }
    
    func getAudioURL() -> String {
        audioURL ?? ""
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setNewsTitle(_ text: String) {
        self.lblTitle.text = text
    }
    
    func setNewsDetail(_ text: String) {
        self.lblDetail.text = text
    }
    
    func setNewsAuthor(_ text: String) {
        self.lblAuthor.text = text
    }
    
    func setNewsImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imgNews.image = image
        }
    }
}
