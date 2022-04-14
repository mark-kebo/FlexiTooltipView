//
//  InflectiveTooltipParams.swift
//  
//
//  Created by Dmitry Vorozhbicki on 30/03/2022.
//

import UIKit

public struct InflectiveTooltipConfiguration {
    var backgroundColor: UIColor
    var arrowHeight: CGFloat
    var cornerRadius: CGFloat
    var isNeedShadow: Bool
    var globalBackgroundAlpha: CGFloat
    var tooltipViewInset: CGFloat
    var isTooltipClosable: Bool
    var highlightedViews: [UIView]
    var topAction: InflectiveTooltipActionItem?
    
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

public struct InflectiveTooltipParams {
    let tooltipItems: [InflectiveTooltipItemProtocol]
    let pointingView: UIView
    let configuration: InflectiveTooltipConfiguration
    
    var pointingViewGlobalFrame: CGRect {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return pointingView.superview?.convert(pointingView.frame, to: rootView) ?? .zero
    }
    
    public var width: CGFloat {
        var viewWidth: CGFloat = 0
        tooltipItems.forEach {
            guard $0.contentWidth > viewWidth else { return }
            viewWidth = $0.contentWidth
        }
        viewWidth = max(viewWidth, configuration.arrowHeight + configuration.cornerRadius)
        return viewWidth.rounded(.up)
    }
    
    public init(tooltipItems: [InflectiveTooltipItemProtocol],
                pointingView: UIView,
                configuration: InflectiveTooltipConfiguration? = nil) {
        self.tooltipItems = tooltipItems
        self.pointingView = pointingView
        self.configuration = configuration ?? InflectiveTooltipConfiguration()
    }
}

public protocol InflectiveTooltipItemProtocol {
    var type: InflectiveTooltipItemType { get }
    var contentWidth: CGFloat { get }
}

public enum InflectiveTooltipItemType {
    case text
    case image
    case actions
    
    var reuseId: String {
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

public struct InflectiveTooltipTextItem: InflectiveTooltipItemProtocol {
    public var type: InflectiveTooltipItemType { .text }
    public let text: NSAttributedString
    public let image: UIImage?
    public let imageSize: CGFloat
    public let spacing: CGFloat
    public var contentWidth: CGFloat {
        var width = text.size().width + spacing * 2
        if image != nil {
            width += imageSize + spacing
        }
        return width
    }
    
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

public struct InflectiveTooltipImageItem: InflectiveTooltipItemProtocol {
    public var type: InflectiveTooltipItemType { .image }
    public let image: UIImage?
    public let imageSize: CGSize
    public let spacing: CGFloat
    public var contentWidth: CGFloat {
        imageSize.width + spacing * 2
    }
    
    public init(image: UIImage?,
                imageSize: CGSize,
                spacing: CGFloat = 16) {
        self.image = image
        self.imageSize = imageSize
        self.spacing = spacing
    }
}

public struct InflectiveTooltipActionsItem: InflectiveTooltipItemProtocol {
    public var type: InflectiveTooltipItemType { .actions }
    public let firstAction: InflectiveTooltipActionItem
    public let secondAction: InflectiveTooltipActionItem?
    public let alignment: InflectiveTooltipActionsAlignment
    public let spacing: CGFloat
    public var contentWidth: CGFloat {
        var width = firstAction.contentWidth + (secondAction?.contentWidth ?? 0) + spacing * 2
        if (secondAction?.contentWidth ?? 0) > 0 {
            width += spacing
        }
        return width
    }
    
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

public enum InflectiveTooltipActionsAlignment {
    case leading
    case center
    case trailing
}

public struct InflectiveTooltipActionItem {
    public let title: NSAttributedString
    public let backgroundColor: UIColor
    public let cornerRadius: CGFloat
    public let contentInsets: UIEdgeInsets
    public let completion: (() -> Void)?
    public var contentWidth: CGFloat {
        contentInsets.left + contentInsets.right + title.size().width
    }
    
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
