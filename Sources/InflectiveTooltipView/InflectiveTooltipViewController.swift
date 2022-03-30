//
//  InflectiveTooltipViewController.swift
//  
//
//  Created by Dmitry Vorozhbicki on 30/03/2022.
//

import UIKit

final public class InflectiveTooltipViewController: UIViewController {
    private let screenSize = UIScreen.main.bounds
    private let triangleShape = CAShapeLayer()
        
    private var backgroundView = UIView()
    private let dialogBackgroundView = UIView()
    
    private var minTopInset: CGFloat {
        var topInset: CGFloat = params.tooltipViewInset
        guard let window = UIApplication.shared.keyWindow else { return topInset }
        if #available(iOS 11.0, *) {
            topInset += window.safeAreaInsets.top
        }
        return topInset
    }
    
    private var minBottomInset: CGFloat {
        var bottomInset: CGFloat = params.tooltipViewInset
        guard let window = UIApplication.shared.keyWindow else { return bottomInset }
        if #available(iOS 11.0, *) {
            bottomInset += window.safeAreaInsets.bottom
        }
        return bottomInset
    }
    
    private let params: InflectiveTooltipParams
    
    public required init(params: InflectiveTooltipParams) {
        self.params = params
        super.init()
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        fillViews()
    }
    
    private func prepareViews() {
        dialogBackgroundView.backgroundColor = params.backgroundColor
        dialogBackgroundView.layer.cornerRadius = params.cornerRadius
        backgroundView.alpha = params.globalBackgroundAlpha
        dialogBackgroundView.clipsToBounds = true
        backgroundView.frame = UIScreen.main.bounds
    }
    
    private func fillViews() {
        let tooltipView = params.tooltipView
        tooltipView.layoutSubviews()
        let dialogBackgroundViewHeight = tooltipView.frame.height
        let maxDialogViewHeight = screenSize.height - minTopInset - minBottomInset
        let dialogViewHeight: CGFloat = min(maxDialogViewHeight, dialogBackgroundViewHeight)
        let dialogViewSize = CGSize(width: params.width, height: dialogViewHeight)
        dialogBackgroundView.frame = CGRect(origin: getDialogViewOrign(for: dialogViewSize),
                                            size: dialogViewSize)
        tooltipView.frame = CGRect(x: dialogBackgroundView.frame.minX + params.tooltipViewInset,
                                   y: dialogBackgroundView.frame.minY + params.tooltipViewInset,
                                   width: dialogBackgroundView.frame.width - params.tooltipViewInset * 2,
                                   height: dialogBackgroundView.frame.height - params.tooltipViewInset * 2)
        view.addSubview(backgroundView)
        view.addSubview(dialogBackgroundView)
        view.addSubview(tooltipView)
    }
    
    private func getDialogViewOrign(for size: CGSize) -> CGPoint {
        let globalFrame = params.pointingViewGlobalFrame
        var point = CGPoint.zero
        triangleShape.removeFromSuperlayer()
        let path = CGMutablePath()

        //Right arrow
        if (globalFrame.minX - size.width - params.arrowHeight - params.tooltipViewInset) > 0 {
            let bottomSpaceHeight = max(0, screenSize.height - size.height - globalFrame.midY)
            let y = screenSize.height - (bottomSpaceHeight + size.height) - params.tooltipViewInset * 2
            let x = globalFrame.minX - (params.arrowHeight + size.width)
            point = CGPoint(x: x, y: max(params.tooltipViewInset, y))
            let arrowPoint = CGPoint(x: globalFrame.minX - params.arrowHeight, y: globalFrame.midY - params.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x + params.arrowHeight, y: arrowPoint.y + params.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: arrowPoint.y + params.arrowHeight * 2))
            path.addLine(to: arrowPoint)
        }
        //Bottom arrow
        else if (globalFrame.minY - size.height - params.arrowHeight - minBottomInset) > 0 {
            let rightSpaceHeight = max(0, screenSize.width - size.width - globalFrame.midX)
            let y = globalFrame.minY - size.height - params.arrowHeight
            let x = screenSize.width - rightSpaceHeight - size.width - params.tooltipViewInset * 2
            point = CGPoint(x: max(x, params.tooltipViewInset), y: y)
            let arrowPoint = CGPoint(x: globalFrame.midX - params.arrowHeight, y: globalFrame.minY - params.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x + params.arrowHeight, y: arrowPoint.y + params.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x + params.arrowHeight * 2, y: arrowPoint.y))
            path.addLine(to: arrowPoint)
        }
        //Left arrow
        else if (globalFrame.maxX + size.width + params.arrowHeight + params.tooltipViewInset) < screenSize.width {
            let bottomSpaceHeight = max(0, screenSize.height - size.height - globalFrame.midY)
            let y = screenSize.height - (bottomSpaceHeight + size.height) - params.tooltipViewInset * 2
            let x = globalFrame.maxX + params.arrowHeight
            point = CGPoint(x: x, y: max(y, params.tooltipViewInset))
            let arrowPoint = CGPoint(x: globalFrame.maxX + params.arrowHeight, y: globalFrame.midY - params.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x - params.arrowHeight, y: arrowPoint.y + params.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: arrowPoint.y + params.arrowHeight * 2))
            path.addLine(to: arrowPoint)
        }
        //Top arrow
        else {
            let rightSpaceHeight = max(0, screenSize.width - size.width - globalFrame.midX)
            let y = globalFrame.maxY + params.arrowHeight
            let x = screenSize.width - rightSpaceHeight - size.width - params.tooltipViewInset * 2
            point = CGPoint(x: max(x, params.tooltipViewInset), y: y)
            let arrowPoint = CGPoint(x: globalFrame.midX - params.arrowHeight, y: globalFrame.maxY + params.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x + params.arrowHeight, y: arrowPoint.y - params.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x + params.arrowHeight * 2, y: arrowPoint.y))
            path.addLine(to: arrowPoint)
        }
        triangleShape.path = path
        triangleShape.fillColor = UIColor.white.cgColor
        backgroundView.layer.addSublayer(triangleShape)
        return point
    }
}
