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
    @IBOutlet weak var audioImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    static let reuseIdentifier = String(describing: HomeTableViewCell.self)
    
    var cellPresenter: HomeCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform.identity
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
