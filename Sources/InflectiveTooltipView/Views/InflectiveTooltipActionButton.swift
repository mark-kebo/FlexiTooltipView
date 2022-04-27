//
//  InflectiveTooltipView
//  InflectiveTooltipActionButton.swift
//  
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/InflectiveTooltipView

import UIKit

/// Custom tooltip button
final class InflectiveTooltipActionButton: UIButton {
    /// Add background color to button
    /// - Parameters:
    ///   - color: Backgtound color
    ///   - forState: UIControl State
    func setBackgroundColor(color: UIColor?, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor((color ?? .clear).cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
