//
//  DetailViewController.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    
    func setTitle(_ title: String)
    func setAudioTitle(_ text: String)
    func setAuidoArtistName(_ text: String)
    func setPlayButtonImage()
    func setAudioImage(_ image: UIImage)
    
    func getAudioURL() -> String
    func getAudioTitle() -> String
    func getAudioArtistNmae() -> String
    func getAudioImageURL() -> URL
}

final class DetailViewController: BaseViewController {

    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var audioTitleLabel: UILabel!
    @IBOutlet weak var audioArtistNameLabel: UILabel!
    @IBOutlet weak var playButtonImage: UIImageView!
    
    @IBOutlet weak var favoriButtonImage: UIImageView!
    
    var presenter: DetailPresenterProtocol!
    
   
    var audioURL: String?
    var audioTitle: String?
    var audioArtistName: String?
    var adudioImageURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
//
//        view.layer.cornerRadius = 40
//            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//            view.layer.masksToBounds = true
      
    }
  
    @IBAction func playButton(_ sender: Any) {
        presenter.playAudio(for: audioURL ?? "")
        setPlayButtonImage()
    }
    
    @IBAction func favoriButton(_ sender: Any) {
        setFavoriButtonImage()
    }
    
    
//    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view)
//
//        switch gesture.state {
//        case .changed:
//            if translation.y > 0 {
//                let cornerRadius = max(40 - (translation.y / view.bounds.height) * 40, 0) // Köşe yuvarlaklığı değerini hesaplayın ve minimum değeri 0 olarak ayarlayın
//                view.layer.cornerRadius = cornerRadius
//                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Sadece üst köşeleri yuvarla
//                view.layer.masksToBounds = true
//                view.transform = CGAffineTransform(translationX: 0, y: translation.y) // Sayfayı aşağıya kaydırın
//
//            }
//        case .ended:
//            let velocity = gesture.velocity(in: view)
//
//            if translation.y > 200 || velocity.y > 500 {
//                dismiss(animated: true, completion: nil)
//            } else {
//                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//                    self.view.transform = .identity // Sayfayı sıfır konumuna geri döndürün
//                    self.view.layer.cornerRadius = 0 // Köşe yuvarlaklığını sıfıra ayarlayın
//                    self.view.layer.maskedCorners = [] // Köşe yuvarlaklığı maskesini kaldırın
//                }, completion: nil)
//            }
//        default:
//            break
//        }
//    }
//

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                let cornerRadius = max(40 - (translation.y / view.bounds.height) * 40, 0)
                view.layer.cornerRadius = cornerRadius
                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)

                // Üste gölge ekle
                view.layer.shadowColor = UIColor.black.cgColor
                view.layer.shadowOpacity = 0.2
                view.layer.shadowOffset = CGSize(width: 0, height: -3)
                view.layer.shadowRadius = 3
            }
        case .ended:
            let velocity = gesture.velocity(in: view)

            if translation.y > 200 || velocity.y > 500 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                    self.view.layer.cornerRadius = 0
                    self.view.layer.maskedCorners = []
                    self.view.layer.shadowOpacity = 0 // Gölgeyi kaldır
                }, completion: nil)
            }
        default:
            break
        }
    }



}

extension DetailViewController: DetailViewControllerProtocol {
    
    func setAudioImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.audioImageView.image = image
        }
    }
    
    func getAudioArtistNmae() -> String {
        audioArtistName ?? ""
    }
    
    func getAudioImageURL() -> URL {
        URL(string: adudioImageURL ?? "")!
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
    
    func setAudioTitle(_ text: String) {
        self.audioTitleLabel.text = text
    }
    
    func setAuidoArtistName(_ text: String) {
        self.audioArtistNameLabel.text = text
    }
    
    func setPlayButtonImage() {
        if let currentImage = playButtonImage.image {
            if currentImage == UIImage(systemName: "pause.fill") {
                UIView.animate(withDuration: 0.2, animations: {
                    self.playButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.playButtonImage.image = UIImage(systemName: "play.fill")
                    UIView.animate(withDuration: 0.2) {
                        self.playButtonImage.transform = .identity
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.playButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.playButtonImage.image = UIImage(systemName: "pause.fill")
                    UIView.animate(withDuration: 0.2) {
                        self.playButtonImage.transform = .identity
                    }
                }
            }
        }
    }
    
    func setFavoriButtonImage() {
        if let currentImage = favoriButtonImage.image {
            if currentImage == UIImage(systemName: "star.fill") {
                UIView.animate(withDuration: 0.2, animations: {
                    self.favoriButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.favoriButtonImage.image = UIImage(systemName: "star")
                    UIView.animate(withDuration: 0.2) {
                        self.favoriButtonImage.transform = .identity
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.favoriButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.favoriButtonImage.image = UIImage(systemName: "star.fill")
                    UIView.animate(withDuration: 0.2) {
                        self.favoriButtonImage.transform = .identity
                    }
                }
            }
        }
    }
}
