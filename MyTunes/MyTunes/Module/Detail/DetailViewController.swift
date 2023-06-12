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
    func getAudioImageURL() -> String
    func getTrackId() -> Int
}

final class DetailViewController: BaseViewController {

    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var audioTitleLabel: UILabel!
    @IBOutlet weak var audioArtistNameLabel: UILabel!
    @IBOutlet weak var playButtonImage: UIImageView!
    @IBOutlet weak var favoriButtonImage: UIImageView!
    @IBOutlet weak var nextButtonImage: UIImageView!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressStartLabel: UILabel!
    @IBOutlet weak var progressEndLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var presenter: DetailPresenterProtocol!
    var audioURL: String?
    var audioTitle: String?
    var audioArtistName: String?
    var audioImageURL: String?
    var audioTrackId: Int?
    var audioIndex: Int?
    var maxAudioIndex: Int?
    var isAnimating = false
    
    var counter: Int = 0
    var timer: Timer?
    var previousCounter: Int = 0
    
    var startTimer: Timer?
    var endTimer: Timer?
    var startCounter: Int = 0
    var endCounter: Int = -28
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0.0
                
                progressView.layer.cornerRadius = 4
                progressView.clipsToBounds = true
                progressView.layer.sublayers![1].cornerRadius = 4
                progressView.subviews[1].clipsToBounds = true
        
        presenter.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        viewFavoriButtonImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toggleAnimation()
        presenter.playAudio(for: audioURL ?? "")
        setPlayButtonImage()
        progressViewStartStop()
        progressLabelSet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter.viewDidDisappear()
     
    }
  
    @IBAction func playButton(_ sender: Any) {
      
        toggleAnimation()
        presenter.playAudio(for: audioURL ?? "")
        setPlayButtonImage()
        progressViewStartStop()
        progressLabelSet()
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
               self.nextButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
           }) { (_) in
               UIView.animate(withDuration: 0.2) {
                   self.nextButtonImage.transform = CGAffineTransform.identity
               }
           }
        
        print("next")
       

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: false)
            let nextIndex = min((self.audioIndex ?? 1) + 1, (self.maxAudioIndex ?? 1) - 1)
            NotificationCenter.default.post(name: Notification.Name("NextIndexSelected"), object: nextIndex)
        }

        

    }
    
    @IBAction func backButton(_ sender: Any) {
        print("back")
        
        
        UIView.animate(withDuration: 0.2, animations: {
               self.backButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
           }) { (_) in
               UIView.animate(withDuration: 0.2) {
                   self.backButtonImage.transform = CGAffineTransform.identity
               }
           }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: false)
            var backIndex = self.audioIndex ?? 0
            backIndex -= 1
            backIndex = max(backIndex, 0)
            NotificationCenter.default.post(name: Notification.Name("NextIndexSelected"), object: backIndex)
        }
    }
    
    @IBAction func favoriButton(_ sender: Any) {
        setFavoriButtonImage()
        presenter.favoriButtonTapped()
        print(
            CoreDataManager.shared.fetchAudioData()
        )
    }

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

    func toggleAnimation() {
        if isAnimating {
            stopScaleAnimation()
        } else {
            startScaleAnimation()
        }
        
        isAnimating = !isAnimating
    }

    func startScaleAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.04
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount =  0// .infinity
        
        audioImageView.layer.add(animation, forKey: "scaleAnimation")
    }

    func stopScaleAnimation() {
        guard let presentationLayer = audioImageView.layer.presentation() else {
            return
        }
        
        let currentScale = presentationLayer.transform.m11
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = NSNumber(value: Float(currentScale))
        animation.toValue = NSNumber(value: 1.0)
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        audioImageView.layer.add(animation, forKey: "scaleAnimation")
    }


    func progressViewStartStop() {
        if timer == nil {
            if counter >= 100 {
                counter = 0
            } else {
                counter = previousCounter
            }
            progressView.progress = Float(counter) / Float(100)
            
            let interval = 0.3 // Değişen kısım: Her 0.3 saniyede bir artış
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                self.counter += 1
                self.previousCounter = self.counter
                
                let progress = Float(self.counter) / Float(100)
                self.progressView.setProgress(progress, animated: true)
                
                if self.counter >= 100 {
                    timer.invalidate()
                    self.timer = nil
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }

    @objc func updateStartLabel() {
           if startCounter <= 28 {
               progressStartLabel.text = "\(startCounter)"
               startCounter += 1
             
           } else {
               startTimer?.invalidate()
               startTimer = nil
               setPlayButtonImage()
           }
       }

   @objc func updateEndLabel() {
       if endCounter <= 0 {
           progressEndLabel.text = "\(endCounter)"
           endCounter += 1

       } else {
           endTimer?.invalidate()
           endTimer = nil
       }
   }

    func progressLabelSet() {
        if startTimer == nil {
          
            if startCounter > 28 {
                startCounter = 0 // Başa dönmek için startCounter'ı sıfırla
            }
            startTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStartLabel), userInfo: nil, repeats: true)
        } else {
            startTimer?.invalidate()
            startTimer = nil
        }

        if endTimer == nil {
            if endCounter > 0 {
                endCounter = -28 // Başa dönmek için startCounter'ı sıfırla
            }
            endTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateEndLabel), userInfo: nil, repeats: true)
        } else {
            endTimer?.invalidate()
            endTimer = nil
        }
    }
    
}

extension DetailViewController: DetailViewControllerProtocol {
  
    func getTrackId() -> Int {
        audioTrackId ?? 1
    }
    
    func getAudioArtistNmae() -> String {
        audioArtistName ?? ""
    }
    
//    func getAudioImageURL() -> URL {
//        URL(string: audioImageURL ?? "")!
//
//    }
    
    func getAudioImageURL() -> URL {
        var modifiedURLString = audioImageURL ?? ""
        
        if let range = modifiedURLString.range(of: "100x100bb.jpg") {
            modifiedURLString.replaceSubrange(range, with: "500x500bb.jpg")
        }
        
        return URL(string: modifiedURLString)!
    }
    
    func getAudioImageURL() -> String {
        audioImageURL ?? ""
    }
    
    
    func getAudioTitle() -> String {
        audioTitle ?? ""
    }
    
    func getAudioURL() -> String {
        audioURL ?? ""
    }
    
    func setAudioImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.audioImageView.image = image
        }
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
    
    func viewFavoriButtonImage() {
        if presenter.isTrackIdSaved(audioTrackId ?? 1) {
            favoriButtonImage.image = UIImage(systemName: "bookmark.fill")
        } else {
            favoriButtonImage.image = UIImage(systemName: "bookmark")
        }
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
            if currentImage == UIImage(systemName: "bookmark.fill") {
                UIView.animate(withDuration: 0.2, animations: {
                    self.favoriButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.favoriButtonImage.image = UIImage(systemName: "bookmark")
                    UIView.animate(withDuration: 0.2) {
                        self.favoriButtonImage.transform = .identity
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.favoriButtonImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.favoriButtonImage.image = UIImage(systemName: "bookmark.fill")
                    UIView.animate(withDuration: 0.2) {
                        self.favoriButtonImage.transform = .identity
                    }
                }
            }
        }
    }
}
