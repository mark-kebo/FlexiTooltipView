//
//  FlexiTooltipView
//  FlexiTooltipActionsTableViewCell.swift
//
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/FlexiTooltipView

import UIKit

/// Custom table view cell for actions
final class FlexiTooltipActionsTableViewCell: UITableViewCell {
    private let stackView = UIStackView()
    private let firstActionButton = FlexiTooltipActionButton()
    private let secondActionButton = FlexiTooltipActionButton()

    private let defaultConstraint: CGFloat = 16
    private let buttonHighlightedAlpha: CGFloat = 0.6
    private let defaultConstraintPriority = UILayoutPriority(999)
    private var leadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var trailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var greaterTrailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var greaterLeadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var centerConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var firstActionWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var secondActionWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    /// Data item to configurate cell
    public var viewDataItem: FlexiTooltipActionsItem? {
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
        firstActionWidthConstraint = firstActionButton.widthAnchor.constraint(equalToConstant: 0)
        secondActionWidthConstraint = secondActionButton.widthAnchor.constraint(equalToConstant: 0)
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
        let additionalButtonSpacing = spacing * 1.5
        stackView.spacing = spacing
        leadingConstraint.constant = spacing
        trailingConstraint.constant = -spacing
        firstActionButton.setAttributedTitle(viewDataItem?.firstAction.title, for: .normal)
        if let selectedFirstAction = viewDataItem?.firstAction {
            let mutableAttributedString = NSMutableAttributedString(attributedString: selectedFirstAction.title)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                 value: UIColor.lightGray,
                                                 range: NSMakeRange(0, selectedFirstAction.title.length))
            firstActionButton.setAttributedTitle(mutableAttributedString, for: .highlighted)
        }
        firstActionButton.setBackgroundColor(color: viewDataItem?.firstAction.backgroundColor, forState: .normal)
        firstActionButton.setBackgroundColor(color: viewDataItem?.firstAction.backgroundColor.withAlphaComponent(buttonHighlightedAlpha),
                                             forState: .highlighted)
        firstActionButton.contentEdgeInsets = viewDataItem?.firstAction.contentInsets ?? UIEdgeInsets.zero
        firstActionButton.layer.cornerRadius = viewDataItem?.firstAction.cornerRadius ?? 0
        firstActionButton.clipsToBounds = true
        firstActionButton.addTarget(self, action: #selector(firstButtonAction(_:)), for: .touchUpInside)
        secondActionButton.setAttributedTitle(viewDataItem?.secondAction?.title, for: .normal)
        if let selectedSecondAction = viewDataItem?.secondAction {
            let mutableAttributedString = NSMutableAttributedString(attributedString: selectedSecondAction.title)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                 value: UIColor.lightGray,
                                                 range: NSMakeRange(0, selectedSecondAction.title.length))
            secondActionButton.setAttributedTitle(mutableAttributedString, for: .highlighted)
        }
        secondActionButton.setBackgroundColor(color: viewDataItem?.secondAction?.backgroundColor, forState: .normal)
        secondActionButton.setBackgroundColor(color: viewDataItem?.secondAction?.backgroundColor.withAlphaComponent(buttonHighlightedAlpha),
                                              forState: .highlighted)
        secondActionButton.contentEdgeInsets = viewDataItem?.secondAction?.contentInsets ?? UIEdgeInsets.zero
        secondActionButton.layer.cornerRadius = viewDataItem?.secondAction?.cornerRadius ?? 0
        secondActionButton.clipsToBounds = true
        secondActionButton.isHidden = viewDataItem?.secondAction == nil
        secondActionButton.addTarget(self, action: #selector(secondButtonAction(_:)), for: .touchUpInside)
        guard (viewDataItem?.contentWidth ?? 0) < self.frame.width else {
            firstActionWidthConstraint.constant = self.frame.width / 2 - additionalButtonSpacing
            secondActionWidthConstraint.constant = self.frame.width / 2 - additionalButtonSpacing
            NSLayoutConstraint.activate([ firstActionWidthConstraint, secondActionWidthConstraint ])
            return
        }
        switch viewDataItem?.alignment {
        case .trailing:
            greaterTrailingConstraint.priority = .defaultLow
            greaterLeadingConstraint.priority = defaultConstraintPriority
            leadingConstraint.priority = .defaultLow
            trailingConstraint.priority = defaultConstraintPriority
            NSLayoutConstraint.deactivate([ centerConstraint, firstActionWidthConstraint, secondActionWidthConstraint ])
        case .leading:
            greaterTrailingConstraint.priority = defaultConstraintPriority
            greaterLeadingConstraint.priority = .defaultLow
            leadingConstraint.priority = defaultConstraintPriority
            trailingConstraint.priority = .defaultLow
            NSLayoutConstraint.deactivate([ centerConstraint, firstActionWidthConstraint, secondActionWidthConstraint ])
        case .center:
            greaterTrailingConstraint.priority = defaultConstraintPriority
            greaterLeadingConstraint.priority = defaultConstraintPriority
            leadingConstraint.priority = .defaultLow
            trailingConstraint.priority = .defaultLow
            NSLayoutConstraint.activate([ centerConstraint, firstActionWidthConstraint, secondActionWidthConstraint ])
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
