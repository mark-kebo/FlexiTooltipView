//
//  InflectiveTooltipActionButton.swift
//  
//
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//

import UIKit

final class InflectiveTooltipActionButton: UIButton {
    func setBackgroundColor(color: UIColor?, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor((color ?? .clear).cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
