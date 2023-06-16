//
//  HomeTableViewCell.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 6.06.2023.
//

import UIKit

protocol HomeCellProtocol: AnyObject {
    func setImage(_ image: UIImage)
    func setTitle(_ text: String)
    func setAuthor(_ text: String)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var playUIView: UIView!
    @IBOutlet weak var playImage: UIImageView!
    
    static let reuseIdentifier = String(describing: HomeTableViewCell.self)
    var playingIndexPath: Int?
    
    var cellPresenter: HomeCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playImage.image = UIImage(systemName: "play.fill")
    }
    
    @IBAction func playButton(_ sender: Any) {
        self.setPlayButtonImage()
        self.cellPresenter?.playAudio(for: self.cellPresenter.getAudioURL())
    }

    func setPlayButtonImage() {
        if let currentImage = playImage.image {
            if currentImage == UIImage(systemName: "pause.fill") {
                UIView.animate(withDuration: 0.2, animations: {
                    self.playImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.playImage.image = UIImage(systemName: "play.fill")
                    UIView.animate(withDuration: 0.2) {
                        self.playImage.transform = .identity
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.playImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (_) in
                    self.playImage.image = UIImage(systemName: "pause.fill")
                    UIView.animate(withDuration: 0.2) {
                        self.playImage.transform = .identity
                    }
                }
            }
        }
    }
}

extension HomeTableViewCell: HomeCellProtocol {
    
    func setImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.audioImage.image = image
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setAuthor(_ text: String) {
        starLabel.text = text
    }
}
