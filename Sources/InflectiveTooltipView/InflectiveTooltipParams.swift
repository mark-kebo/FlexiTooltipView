//
//  InflectiveTooltipView
//  InflectiveTooltipParams.swift
//
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/InflectiveTooltipView

import UIKit

/// Basic tooltip configuration item
public struct InflectiveTooltipConfiguration {
    ///Tooltip background color
    public var backgroundColor: UIColor
    
    /// Height of tooltip arrow
    public var arrowHeight: CGFloat
    
    /// Tooltip corner radius
    public var cornerRadius: CGFloat
    
    /// Tooltip shadow
    public var isNeedShadow: Bool
    
    /// Background transparency
    public var globalBackgroundAlpha: CGFloat
    
    /// Margins from the edges of the tooltip
    public var tooltipViewInset: CGFloat
    
    /// Button to close the tooltip
    public var isTooltipClosable: Bool
    
    /// Highlighted views (if 'globalBackgroundAlpha' < 1)
    public var highlightedViews: [UIView]
    
    /// Action item for top global button if needed
    public var topAction: InflectiveTooltipActionItem?
    
    /// Default init
    public init() {
        backgroundColor = .white
        arrowHeight = 8
        cornerRadius = 8
        isNeedShadow = false
        globalBackgroundAlpha = 0.3
        tooltipViewInset = 16
        isTooltipClosable = false
        highlightedViews = []
    }
}

/// Tooltip params for configuration
public struct InflectiveTooltipParams {
    /// All tooltip basic view data items
    public let tooltipItems: [InflectiveTooltipItemProtocol]
    
    /// UIView to which the tooltip will be attached
    public let pointingView: UIView
    
    /// Basic tooltip configuration item
    public let configuration: InflectiveTooltipConfiguration
    
    /// Global frame of UIView to which the tooltip will be attached
    public var pointingViewGlobalFrame: CGRect {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return pointingView.superview?.convert(pointingView.frame, to: rootView) ?? .zero
    }
    
    /// Tooltip width
    public var width: CGFloat {
        var viewWidth: CGFloat = 0
        tooltipItems.forEach {
            guard $0.contentWidth > viewWidth else { return }
            viewWidth = $0.contentWidth
        }
        viewWidth = max(viewWidth, configuration.arrowHeight + configuration.cornerRadius)
        return viewWidth.rounded(.up)
    }
    
    /// Basic setup init
    /// - Parameters:
    ///   - tooltipItems: All tooltip basic view data items
    ///   - pointingView: UIView to which the tooltip will be attached
    ///   - configuration: Basic tooltip configuration item
    public init(tooltipItems: [InflectiveTooltipItemProtocol],
                pointingView: UIView,
                configuration: InflectiveTooltipConfiguration? = nil) {
        self.tooltipItems = tooltipItems
        self.pointingView = pointingView
        self.configuration = configuration ?? InflectiveTooltipConfiguration()
    }
}

/// Interface of tooltip view data item
public protocol InflectiveTooltipItemProtocol {
    /// Type of tooltip item
    var type: InflectiveTooltipItemType { get }
    
    /// Cell content width
    var contentWidth: CGFloat { get }
}

/// Type of tooltip item
public enum InflectiveTooltipItemType {
    /// Item for attributted text with image
    case text
    
    /// Item for custom image
    case image
    
    /// Item for custom actions
    case actions
    
    /// Cell reuse id
    public var reuseId: String {
        switch self {
        case .text:
            return String(describing: InflectiveTooltipTextTableViewCell.self)
        case .image:
            return String(describing: InflectiveTooltipImageTableViewCell.self)
        case .actions:
            return String(describing: InflectiveTooltipActionsTableViewCell.self)
        }
    }
}

/// Item for attributted text with image
public struct InflectiveTooltipTextItem: InflectiveTooltipItemProtocol {
    /// Type of tooltip item
    public var type: InflectiveTooltipItemType { .text }
    
    /// Attributed text
    public let text: NSAttributedString
    
    /// Image if needed
    public let image: UIImage?
    
    /// Image size if needed
    public let imageSize: CGFloat
    
    /// Content spacing if needed
    public let spacing: CGFloat
    
    /// Cell content width
    public var contentWidth: CGFloat {
        var width = text.size().width + spacing * 2
        if image != nil {
            width += imageSize + spacing
        }
        return width
    }
    
    /// Basic setup init
    /// - Parameters:
    ///   - text: Attributed text
    ///   - image: Image if needed
    ///   - imageSize: Image size if needed
    ///   - spacing: Content spacing if needed
    public init(text: NSAttributedString,
                image: UIImage?,
                imageSize: CGFloat = 20,
                spacing: CGFloat = 16) {
        self.text = text
        self.image = image
        self.imageSize = imageSize
        self.spacing = spacing
    }
}

/// Item for custom image
public struct InflectiveTooltipImageItem: InflectiveTooltipItemProtocol {
    /// Type of tooltip item
    public var type: InflectiveTooltipItemType { .image }
    
    /// Image if needed
    public let image: UIImage?
    
    /// Image size if needed
    public let imageSize: CGSize
    
    /// Content spacing if needed
    public let spacing: CGFloat
    
    /// Cell content width
    public var contentWidth: CGFloat {
        imageSize.width + spacing * 2
    }
    
    /// Basic setup init
    /// - Parameters:
    ///   - image: Image if needed
    ///   - imageSize: Image size if needed
    ///   - spacing: Content spacing if needed
    public init(image: UIImage?,
                imageSize: CGSize,
                spacing: CGFloat = 16) {
        self.image = image
        self.imageSize = imageSize
        self.spacing = spacing
    }
}

/// Item for custom actions
public struct InflectiveTooltipActionsItem: InflectiveTooltipItemProtocol {
    /// Type of tooltip item
    public var type: InflectiveTooltipItemType { .actions }
    
    /// View data item for first action
    public let firstAction: InflectiveTooltipActionItem
    
    /// View data item for second action
    public let secondAction: InflectiveTooltipActionItem?
    
    /// Actions alignment
    public let alignment: InflectiveTooltipActionsAlignment
    
    /// Content spacing if needed
    public let spacing: CGFloat
    
    /// Cell content width
    public var contentWidth: CGFloat {
        var width = firstAction.contentWidth + (secondAction?.contentWidth ?? 0) + spacing * 2
        if (secondAction?.contentWidth ?? 0) > 0 {
            width += spacing
        }
        return width
    }
    
    /// Basic setup init
    /// - Parameters:
    ///   - firstAction: View data item for first action
    ///   - secondAction: View data item for second action
    ///   - alignment: Actions alignment
    ///   - spacing: Content spacing if needed
    public init(firstAction: InflectiveTooltipActionItem,
                secondAction: InflectiveTooltipActionItem?,
                alignment: InflectiveTooltipActionsAlignment,
                spacing: CGFloat = 16) {
        self.firstAction = firstAction
        self.secondAction = secondAction
        self.alignment = alignment
        self.spacing = spacing
    }
}

/// Actions alignment
public enum InflectiveTooltipActionsAlignment {
    /// Left alignment
    case leading
    
    /// Center alignment
    case center
    
    /// Right alignment
    case trailing
}

/// Tooltip action item
public struct InflectiveTooltipActionItem {
    /// Attributed title
    public let title: NSAttributedString
    
    /// Action background color
    public let backgroundColor: UIColor
    
    /// Action corner radius
    public let cornerRadius: CGFloat
    
    /// Action content insets
    public let contentInsets: UIEdgeInsets
    
    /// Action tap completion
    public let completion: (() -> Void)?
    
    /// Cell content width
    public var contentWidth: CGFloat {
        contentInsets.left + contentInsets.right + title.size().width
    }
    
    /// Basic setup init
    /// - Parameters:
    ///   - title: Attributed title
    ///   - backgroundColor: Action background color
    ///   - cornerRadius: Action corner radius
    ///   - contentInsets: Action content insets
    ///   - completion: Action tap completion
    public init(title: NSAttributedString,
                backgroundColor: UIColor = .clear,
                cornerRadius: CGFloat = 8,
                contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
                completion: (() -> Void)?) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.completion = completion
        self.contentInsets = contentInsets
    }
}
