//
//  InflectiveTooltipParams.swift
//  
//
//  Created by Dmitry Vorozhbicki on 30/03/2022.
//

import UIKit

struct InflectiveTooltipParams {
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
}
