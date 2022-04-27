//
//  FlexiTooltipView
//  FlexiTooltipTextTableViewCell.swift
//
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/FlexiTooltipView

import UIKit

/// Custom table view cell to show attributed text with image
final class FlexiTooltipTextTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let tooltipImageView = UIImageView()
    private let tooltipTextLabel = UILabel()
    
    private let defaultConstraint: CGFloat = 8
    private let defaultConstraintPriority = UILayoutPriority(999)
    private var leadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var trailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var imageWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    /// Data item to configurate cell
    public var viewDataItem: FlexiTooltipTextItem? {
        didSet {
            fillViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        prepareConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareConstraints() {
        leadingConstraint = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -defaultConstraint)
        trailingConstraint = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: defaultConstraint)
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -defaultConstraint)
        let topConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: defaultConstraint)
        imageWidthConstraint = tooltipImageView.widthAnchor.constraint(equalToConstant: 0)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(tooltipImageView)
        stackView.addArrangedSubview(tooltipTextLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint.priority = defaultConstraintPriority
        leadingConstraint.priority = defaultConstraintPriority
        trailingConstraint.priority = defaultConstraintPriority
        bottomConstraint.priority = defaultConstraintPriority
        NSLayoutConstraint.activate([ leadingConstraint,
                                      bottomConstraint,
                                      trailingConstraint,
                                      topConstraint,
                                      imageWidthConstraint ])
    }
    
    private func prepareViews() {
        stackView.axis = .horizontal
        tooltipTextLabel.numberOfLines = 0
        tooltipImageView.contentMode = .top
    }
    
    private func fillViews() {
        prepareViews()
        tooltipTextLabel.attributedText = viewDataItem?.text
        let spacing = viewDataItem?.spacing ?? 0
        stackView.spacing = spacing
        leadingConstraint.constant = spacing
        trailingConstraint.constant = -spacing
        imageWidthConstraint.constant = viewDataItem?.imageSize ?? 0
        tooltipImageView.isHidden = viewDataItem?.image == nil
        tooltipImageView.image = viewDataItem?.image
    }
}
