//
//  InflectiveTooltipView
//  InflectiveTooltipCloseTableHeader.swift
//
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/InflectiveTooltipView

import UIKit

/// Delegate to close action
public protocol InflectiveTooltipCloseTableHeaderDelegate: AnyObject {
    func closeButtonPressed()
}

/// Custom table view header to add close button to tooltip
final class InflectiveTooltipCloseTableHeader: UITableViewHeaderFooterView {
    private let headerSize: CGFloat = 32
    private let defaultConstraint: CGFloat = 16
    private let buttonInset: CGFloat = 8
    private let closeSymbol: String = "✕"
    private let closeButton = UIButton()
    
    /// Delegate to close action
    public weak var delegate: InflectiveTooltipCloseTableHeaderDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareConstraints()
        prepareViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareConstraints() {
        let trailingConstraint = closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottomConstraint = closeButton.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor)
        let topConstraint = closeButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        let imageHeightConstraint = closeButton.heightAnchor.constraint(equalToConstant: headerSize)
        let imageWidthConstraint = closeButton.heightAnchor.constraint(equalToConstant: headerSize)
        contentView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ trailingConstraint, topConstraint,
                                      bottomConstraint,
                                      imageWidthConstraint, imageHeightConstraint ])
    }
    
    private func prepareViews() {
        closeButton.setTitle(closeSymbol, for: .normal)
        closeButton.setTitleColor(.gray, for: .normal)
        closeButton.setTitleColor(.lightGray, for: .highlighted)
        closeButton.contentEdgeInsets = UIEdgeInsets(top: buttonInset, left: defaultConstraint,
                                                     bottom: buttonInset, right: defaultConstraint)
        closeButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }

    @objc private func buttonAction(_ sender: UIButton) {
        delegate?.closeButtonPressed()
    }
}
