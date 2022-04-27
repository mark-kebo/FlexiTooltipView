//
//  InflectiveTooltipView
//  InflectiveTooltipActionsTableViewCell.swift
//
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/InflectiveTooltipView

import UIKit

/// Custom table view cell for actions
final class InflectiveTooltipActionsTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let firstActionButton = InflectiveTooltipActionButton()
    private let secondActionButton = InflectiveTooltipActionButton()

    private let defaultConstraint: CGFloat = 16
    private let buttonHighlightedAlpha: CGFloat = 0.6
    private let defaultConstraintPriority = UILayoutPriority(999)
    private var leadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var trailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var greaterTrailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var greaterLeadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var centerConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    /// Data item to configurate cell
    public var viewDataItem: InflectiveTooltipActionsItem? {
        didSet {
            fillViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        stackView.backgroundColor = .clear
        prepareConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareConstraints() {
        greaterTrailingConstraint = stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: defaultConstraint)
        greaterLeadingConstraint = stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: -defaultConstraint)
        leadingConstraint = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -defaultConstraint)
        trailingConstraint = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: defaultConstraint)
        centerConstraint = stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -defaultConstraint)
        let topConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: defaultConstraint)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(firstActionButton)
        stackView.addArrangedSubview(secondActionButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint.priority = defaultConstraintPriority
        trailingConstraint.priority = defaultConstraintPriority
        NSLayoutConstraint.activate([ leadingConstraint, trailingConstraint,
                                      bottomConstraint, topConstraint,
                                      greaterTrailingConstraint, greaterLeadingConstraint])
    }
    
    private func prepareViews() {
        stackView.axis = .horizontal
    }
    
    private func fillViews() {
        prepareViews()
        let spacing = viewDataItem?.spacing ?? 0
        stackView.spacing = spacing
        leadingConstraint.constant = spacing
        trailingConstraint.constant = -spacing
        firstActionButton.setAttributedTitle(viewDataItem?.firstAction.title, for: .normal)
        firstActionButton.setBackgroundColor(color: viewDataItem?.firstAction.backgroundColor, forState: .normal)
        firstActionButton.setBackgroundColor(color: viewDataItem?.firstAction.backgroundColor.withAlphaComponent(buttonHighlightedAlpha),
                                             forState: .highlighted)
        firstActionButton.contentEdgeInsets = viewDataItem?.firstAction.contentInsets ?? UIEdgeInsets.zero
        firstActionButton.layer.cornerRadius = viewDataItem?.firstAction.cornerRadius ?? 0
        firstActionButton.clipsToBounds = true
        firstActionButton.addTarget(self, action: #selector(firstButtonAction(_:)), for: .touchUpInside)
        secondActionButton.setAttributedTitle(viewDataItem?.secondAction?.title, for: .normal)
        secondActionButton.setBackgroundColor(color: viewDataItem?.secondAction?.backgroundColor, forState: .normal)
        secondActionButton.setBackgroundColor(color: viewDataItem?.secondAction?.backgroundColor.withAlphaComponent(buttonHighlightedAlpha),
                                              forState: .highlighted)
        secondActionButton.contentEdgeInsets = viewDataItem?.secondAction?.contentInsets ?? UIEdgeInsets.zero
        secondActionButton.layer.cornerRadius = viewDataItem?.secondAction?.cornerRadius ?? 0
        secondActionButton.clipsToBounds = true
        secondActionButton.isHidden = viewDataItem?.secondAction == nil
        secondActionButton.addTarget(self, action: #selector(secondButtonAction(_:)), for: .touchUpInside)
        switch viewDataItem?.alignment {
        case .trailing:
            greaterTrailingConstraint.priority = .defaultLow
            greaterLeadingConstraint.priority = defaultConstraintPriority
            leadingConstraint.priority = .defaultLow
            trailingConstraint.priority = defaultConstraintPriority
            NSLayoutConstraint.deactivate([ centerConstraint ])
        case .leading:
            greaterTrailingConstraint.priority = defaultConstraintPriority
            greaterLeadingConstraint.priority = .defaultLow
            leadingConstraint.priority = defaultConstraintPriority
            trailingConstraint.priority = .defaultLow
            NSLayoutConstraint.deactivate([ centerConstraint ])
        case .center:
            greaterTrailingConstraint.priority = defaultConstraintPriority
            greaterLeadingConstraint.priority = defaultConstraintPriority
            leadingConstraint.priority = .defaultLow
            trailingConstraint.priority = .defaultLow
            NSLayoutConstraint.activate([ centerConstraint ])
        default:
            break
        }
    }
    
    @objc private func firstButtonAction(_ sender: UIButton) {
        viewDataItem?.firstAction.completion?()
    }
    
    @objc private func secondButtonAction(_ sender: UIButton) {
        viewDataItem?.secondAction?.completion?()
    }
}
