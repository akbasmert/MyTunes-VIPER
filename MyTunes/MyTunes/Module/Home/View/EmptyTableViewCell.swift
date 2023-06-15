//
//  EmptyTableViewCell.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 10.06.2023.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    let customImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCustomImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomImageView()
    }
    
    private func setupCustomImageView() {
        customImageView.contentMode = .scaleAspectFit
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.tintColor = .systemPink
        contentView.addSubview(customImageView)
        
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 90),
            customImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -110),
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            customImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -70)
        ])
        customImageView.image = UIImage(named: "noresults")
    }
}

