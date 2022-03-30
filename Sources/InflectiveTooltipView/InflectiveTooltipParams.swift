//
//  InflectiveTooltipParams.swift
//  
//
//  Created by Dmitry Vorozhbicki on 30/03/2022.
//

import UIKit

public struct InflectiveTooltipParams {
    let tooltipView: UIView
    let pointingViewGlobalFrame: CGRect
    let isPointingViewSelected: Bool = false
    let width: CGFloat = 235
    let backgroundColor: UIColor = .white
    let arrowHeight: CGFloat = 8
    let cornerRadius: CGFloat = 8
    let isNeedShadow: Bool = false
    let globalBackgroundAlpha: CGFloat = 0.3
    let tooltipViewInset: CGFloat = 14
    
    public init(tooltipView: UIView,
                pointingViewGlobalFrame: CGRect,
                isPointingViewSelected: Bool = false,
                width: CGFloat = 235,
                backgroundColor: UIColor = .white,
                arrowHeight: CGFloat = 8,
                cornerRadius: CGFloat = 8,
                isNeedShadow: Bool = false,
                globalBackgroundAlpha: CGFloat = 0.3,
                tooltipViewInset: CGFloat = 14) {
        self.tooltipView = tooltipView
        self.pointingViewGlobalFrame = pointingViewGlobalFrame
        self.isPointingViewSelected = isPointingViewSelected
        self.width = width
        self.backgroundColor = backgroundColor
        self.arrowHeight = arrowHeight
        self.cornerRadius = cornerRadius
        self.isNeedShadow = isNeedShadow
        self.globalBackgroundAlpha = globalBackgroundAlpha
        self.tooltipViewInset = tooltipViewInset
    }
}
