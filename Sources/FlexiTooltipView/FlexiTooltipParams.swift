//
//  FlexiTooltipView
//  FlexiTooltipParams.swift
//
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/FlexiTooltipView

import UIKit

/// Basic tooltip configuration item
public struct FlexiTooltipConfiguration {
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
    public var topAction: FlexiTooltipActionItem?
    
    /// Is user can close tooltip by background tap
    public var isBackgroundTapClosable: Bool
    
    /// View show/hide animation duration
    public var showHideAnimationDuration: CGFloat
    
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
        isBackgroundTapClosable = false
        showHideAnimationDuration = 0.3
    }
}

/// Tooltip params for configuration
public struct FlexiTooltipParams {
    /// All tooltip basic view data items
    public let tooltipItems: [FlexiTooltipItemProtocol]
    
    /// UIView to which the tooltip will be attached
    public let targetView: UIView?
    
    /// UIView center
    public let viewRect: CGRect?
    
    /// Basic tooltip configuration item
    public let configuration: FlexiTooltipConfiguration
    
    /// Global frame of UIView to which the tooltip will be attached
    public var targetViewGlobalFrame: CGRect {
        guard let viewRect else {
            let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
            return targetView?.superview?.convert(targetView?.frame ?? CGRect.zero, to: rootView) ?? .zero
        }
        return viewRect
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
    public init(tooltipItems: [FlexiTooltipItemProtocol],
                pointingView: UIView?,
                configuration: FlexiTooltipConfiguration? = nil) {
        self.tooltipItems = tooltipItems
        self.targetView = pointingView
        self.viewRect = nil
        self.configuration = configuration ?? FlexiTooltipConfiguration()
    }
    
    /// Basic setup init
    /// - Parameters:
    ///   - tooltipItems: All tooltip basic view data items
    ///   - viewRect: UIView center
    ///   - configuration: Basic tooltip configuration item
    public init(tooltipItems: [FlexiTooltipItemProtocol],
                viewRect: CGRect?,
                configuration: FlexiTooltipConfiguration? = nil) {
        self.tooltipItems = tooltipItems
        self.targetView = nil
        self.viewRect = viewRect
        self.configuration = configuration ?? FlexiTooltipConfiguration()
    }
}

/// Interface of tooltip view data item
public protocol FlexiTooltipItemProtocol {
    /// Type of tooltip item
    var type: FlexiTooltipItemType { get }
    
    /// Cell content width
    var contentWidth: CGFloat { get }
}

/// Type of tooltip item
public enum FlexiTooltipItemType {
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
            return String(describing: FlexiTooltipTextTableViewCell.self)
        case .image:
            return String(describing: FlexiTooltipImageTableViewCell.self)
        case .actions:
            return String(describing: FlexiTooltipActionsTableViewCell.self)
        }
    }
}

/// Item for attributted text with image
public struct FlexiTooltipTextItem: FlexiTooltipItemProtocol {
    /// Type of tooltip item
    public var type: FlexiTooltipItemType { .text }
    
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
public struct FlexiTooltipImageItem: FlexiTooltipItemProtocol {
    /// Type of tooltip item
    public var type: FlexiTooltipItemType { .image }
    
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
public struct FlexiTooltipActionsItem: FlexiTooltipItemProtocol {
    /// Type of tooltip item
    public var type: FlexiTooltipItemType { .actions }
    
    /// View data item for first action
    public let firstAction: FlexiTooltipActionItem
    
    /// View data item for second action
    public let secondAction: FlexiTooltipActionItem?
    
    /// Actions alignment
    public let alignment: FlexiTooltipActionsAlignment
    
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
    public init(firstAction: FlexiTooltipActionItem,
                secondAction: FlexiTooltipActionItem?,
                alignment: FlexiTooltipActionsAlignment,
                spacing: CGFloat = 16) {
        self.firstAction = firstAction
        self.secondAction = secondAction
        self.alignment = alignment
        self.spacing = spacing
    }
}

/// Actions alignment
public enum FlexiTooltipActionsAlignment {
    /// Left alignment
    case leading
    
    /// Center alignment
    case center
    
    /// Right alignment
    case trailing
}

/// Tooltip action item
public struct FlexiTooltipActionItem {
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
