//
//  InflectiveTooltipImageTableViewCell.swift
//  
//
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//

import UIKit

final class InflectiveTooltipImageTableViewCell: UITableViewCell {
    private let tooltipImageView = UIImageView()
    
    private let defaultConstraint: CGFloat = 16

    private var leadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var trailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var imageHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()

    public var viewDataItem: InflectiveTooltipImageItem? {
        didSet {
            fillViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareConstraints() {
        leadingConstraint = tooltipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                                      constant: -defaultConstraint)
        trailingConstraint = tooltipImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                                        constant: defaultConstraint)
        let bottomConstraint = tooltipImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                        constant: -defaultConstraint)
        let topConstraint = tooltipImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                                  constant: defaultConstraint)
        imageHeightConstraint = tooltipImageView.heightAnchor.constraint(equalToConstant: 0)
        contentView.addSubview(tooltipImageView)
        tooltipImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ imageHeightConstraint, bottomConstraint,
                                      topConstraint, leadingConstraint, trailingConstraint ])
    }
    
    private func fillViews() {
        tooltipImageView.contentMode = .scaleAspectFit
        tooltipImageView.image = viewDataItem?.image
        imageHeightConstraint.constant = viewDataItem?.imageSize.height ?? 0
    }
}
