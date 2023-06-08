//
//  SearchCollectionViewCell.swift
//  MyTunes
//
//  Created by Mert AKBAŞ on 7.06.2023.
//

import UIKit

protocol SearchCollectionViewCellProtocol: AnyObject {
    func setTitle(_ text: String)
}

class SearchCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: SearchCollectionViewCell.self)

    var cellPresenter: SearchCollectionViewCellPresenterProtocol! {
        didSet {
            cellPresenter?.load()
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                containerView.backgroundColor = .darkGray
                titleLabel.textColor = .white
            } else {
                containerView.backgroundColor = .systemGray4
                titleLabel.textColor = .black
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
         configureSubviews()
    }

    required init(cellPresenter: SearchCollectionViewCellPresenter?) {
        self.init()
        self.cellPresenter = cellPresenter
         configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 16.0)
        view.translatesAutoresizingMaskIntoConstraints = false
      //  view.text = "deneme"
        return view
    }()

    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 12.0
        view.axis = .horizontal
        view.spacing = 12.0
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0)

        return view
    }()

    private lazy var cardWidth: NSLayoutConstraint = {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let cons = containerView.heightAnchor.constraint(equalToConstant: 1000)
        cons.isActive = true
        return cons
    }()
}

extension SearchCollectionViewCell {

    static func expectedCardSize(_ targetSize: CGSize) -> CGSize {
        let view = SearchCollectionViewCell()
        let acsize = view.systemLayoutSizeFitting(CGSize(width: 0.0, height: targetSize.height), withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)

        return acsize
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        cardWidth.constant = targetSize.height

        return containerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}

extension SearchCollectionViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        cellPresenter = nil
    }
}

private extension SearchCollectionViewCell {
    func configureSubviews() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)])
    }
}

extension SearchCollectionViewCell: SearchCollectionViewCellProtocol {
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}


