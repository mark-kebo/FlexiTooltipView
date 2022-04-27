//
//  InflectiveTooltipView
//  InflectiveTooltipViewController.swift
//
//  Licensed under Apache License 2.0
//  Created by Dmitry Vorozhbicki on 14/04/2022.
//
//  https://github.com/mark-kebo/InflectiveTooltipView

import UIKit

/// Basic tooltip UIViewController to show
final public class InflectiveTooltipViewController: UIViewController {
    private var screenSize: CGRect { UIScreen.main.bounds }
    private let triangleShape = CAShapeLayer()
    private let showHideAnimationDuration: CGFloat = 0.3
    private let closeTableHeaderId = String(describing: InflectiveTooltipCloseTableHeader.self)
    private let buttonHighlightedAlpha: CGFloat = 0.6

    private let backgroundView = UIView()
    private let dialogBackgroundView = UIView()
    private let tooltipTableView: UITableView = UITableView()
    private let arrowFrameView = UIView()
    private let topActionButton = InflectiveTooltipActionButton()
    private let keyWindow = UIApplication.shared.keyWindow
    
    private var widthConstraint: NSLayoutConstraint?
    
    private var minTopInset: CGFloat {
        var topInset: CGFloat = params.configuration.tooltipViewInset
        guard let window = keyWindow else { return topInset }
        if #available(iOS 11.0, *) {
            topInset += window.safeAreaInsets.top
        }
        return topInset
    }
    
    private var minBottomInset: CGFloat {
        var bottomInset: CGFloat = params.configuration.tooltipViewInset
        guard let window = keyWindow else { return bottomInset }
        if #available(iOS 11.0, *) {
            bottomInset += window.safeAreaInsets.bottom
        }
        return bottomInset
    }
    
    private var dialogViewWidth: CGFloat {
        min(params.width, backgroundView.frame.width * 0.7)
    }
    
    private let params: InflectiveTooltipParams
    
    /// Basic setup init
    /// - Parameter params: Basic tooltip configuration item
    public init(params: InflectiveTooltipParams) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        view.addSubview(dialogBackgroundView)
        view.addSubview(arrowFrameView)
        arrowFrameView.addSubview(topActionButton)
        view.addSubview(tooltipTableView)
        prepareTableView()
        dialogBackgroundView.alpha = 0
        arrowFrameView.alpha = 0
        tooltipTableView.alpha = 0
        prepareTopButton()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tooltipTableView.reloadData()
        self.widthConstraint?.constant = self.dialogViewWidth
        self.prepareViews()
        self.fillViews()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillViews()
        UIView.animate(withDuration: showHideAnimationDuration) { [weak self] in
            self?.dialogBackgroundView.alpha = 1
            self?.arrowFrameView.alpha = 1
            self?.tooltipTableView.alpha = 1
        }
    }
    
    /// Custom presenter for tooltip UIViewController
    /// - Parameters:
    ///   - viewController: Parent UIViewController
    ///   - animated: Presenting animation
    public func present(in viewController: UIViewController?, animated: Bool = true) {
        viewController?.present(self, animated: animated, completion: nil)
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: showHideAnimationDuration, animations: { [weak self] in
            self?.dialogBackgroundView.alpha = 0
            self?.arrowFrameView.alpha = 0
            self?.tooltipTableView.alpha = 0
        }) { _ in
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    private func prepareTableView() {
        if #available(iOS 15.0, *) {
            self.tooltipTableView.sectionHeaderTopPadding = 0
        }
        tooltipTableView.register(InflectiveTooltipTextTableViewCell.self,
                                  forCellReuseIdentifier: InflectiveTooltipItemType.text.reuseId)
        tooltipTableView.register(InflectiveTooltipImageTableViewCell.self,
                                  forCellReuseIdentifier: InflectiveTooltipItemType.image.reuseId)
        tooltipTableView.register(InflectiveTooltipActionsTableViewCell.self,
                                  forCellReuseIdentifier: InflectiveTooltipItemType.actions.reuseId)
        tooltipTableView.register(InflectiveTooltipCloseTableHeader.self,
                                  forHeaderFooterViewReuseIdentifier: closeTableHeaderId)
        tooltipTableView.delegate = self
        tooltipTableView.dataSource = self
        tooltipTableView.bounces = false
        tooltipTableView.separatorStyle = .none
        tooltipTableView.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = tooltipTableView.widthAnchor.constraint(equalToConstant: dialogViewWidth)
        widthConstraint?.isActive = true
        tooltipTableView.layer.cornerRadius = params.configuration.cornerRadius
    }
    
    private func prepareTopButton() {
        guard let topActionItem = params.configuration.topAction else {
            topActionButton.isHidden = true
            return
        }
        topActionButton.addTarget(self, action: #selector(topButtonAction(_:)), for: .touchUpInside)
        topActionButton.frame = CGRect(origin: CGPoint(x: params.configuration.tooltipViewInset,
                                                       y: minTopInset),
                                       size: .zero)
        topActionButton.isHidden = false
        topActionButton.setAttributedTitle(topActionItem.title, for: .normal)
        topActionButton.setBackgroundColor(color: topActionItem.backgroundColor, forState: .normal)
        topActionButton.setBackgroundColor(color: topActionItem.backgroundColor.withAlphaComponent(buttonHighlightedAlpha),
                                             forState: .highlighted)
        topActionButton.contentEdgeInsets = topActionItem.contentInsets
        topActionButton.layer.cornerRadius = topActionItem.cornerRadius
        topActionButton.clipsToBounds = true
        topActionButton.sizeToFit()
    }
    
    private func prepareViews() {
        dialogBackgroundView.backgroundColor = params.configuration.backgroundColor
        dialogBackgroundView.layer.cornerRadius = params.configuration.cornerRadius
        dialogBackgroundView.clipsToBounds = true
        backgroundView.frame = UIScreen.main.bounds
        arrowFrameView.backgroundColor = .clear
        arrowFrameView.frame = backgroundView.frame
        addShadow()
        addBackgroundLayer()
    }
    
    private func addBackgroundLayer() {
        guard !params.configuration.highlightedViews.isEmpty else {
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(params.configuration.globalBackgroundAlpha)
            return
        }
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                    width: backgroundView.frame.width,
                                                    height: backgroundView.frame.height),
                                cornerRadius: 0)
        let rootView = keyWindow?.rootViewController?.view
        params.configuration.highlightedViews.forEach {
            guard let frame = $0.superview?.convert($0.frame, to: rootView) else { return }
            let circlePath = UIBezierPath(roundedRect: frame,
                                          cornerRadius: $0.layer.cornerRadius)
            path.append(circlePath)
        }
        path.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = Float(params.configuration.globalBackgroundAlpha)
        backgroundView.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        backgroundView.layer.addSublayer(fillLayer)
    }
    
    private func addShadow() {
        guard params.configuration.isNeedShadow else { return }
        dialogBackgroundView.layer.masksToBounds = false
        if #available(iOS 13.0, *) {
            dialogBackgroundView.layer.shadowColor = UIColor.label.cgColor
        } else {
            dialogBackgroundView.layer.shadowColor = UIColor.black.cgColor
        }
        dialogBackgroundView.layer.shadowOffset = CGSize.zero
        dialogBackgroundView.layer.shadowOpacity = 0.3
        dialogBackgroundView.layer.shadowRadius = params.configuration.arrowHeight
        dialogBackgroundView.layer.shouldRasterize = true
        dialogBackgroundView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func fillViews() {
        tooltipTableView.layoutSubviews()
        tooltipTableView.sizeToFit()
        let dialogBackgroundViewHeight = tooltipTableView.contentSize.height
        let maxDialogViewHeight = screenSize.height - minTopInset - minBottomInset
        let dialogViewHeight: CGFloat = min(maxDialogViewHeight, dialogBackgroundViewHeight)
        let dialogViewSize = CGSize(width: dialogViewWidth,
                                    height: max(dialogViewHeight, params.configuration.arrowHeight * 2 + params.configuration.tooltipViewInset * 2))
        dialogBackgroundView.frame = CGRect(origin: getDialogViewOrign(for: dialogViewSize),
                                            size: dialogViewSize)
        tooltipTableView.frame = dialogBackgroundView.frame
    }
    
    private func getDialogViewOrign(for size: CGSize) -> CGPoint {
        let globalFrame = params.pointingViewGlobalFrame
        var point = CGPoint.zero
        triangleShape.removeFromSuperlayer()
        let path = CGMutablePath()
        
        //Right arrow
        if (globalFrame.minX - size.width - params.configuration.arrowHeight - params.configuration.tooltipViewInset) > 0 {
            let bottomSpaceHeight = max(0, screenSize.height - size.height - globalFrame.midY)
            let y = screenSize.height - (bottomSpaceHeight + size.height) - params.configuration.tooltipViewInset * 2
            let x = globalFrame.minX - (params.configuration.arrowHeight + size.width)
            point = CGPoint(x: x, y: max(params.configuration.tooltipViewInset, y))
            let arrowPoint = CGPoint(x: globalFrame.minX - params.configuration.arrowHeight,
                                     y: globalFrame.midY - params.configuration.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x + params.configuration.arrowHeight,
                                     y: arrowPoint.y + params.configuration.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: arrowPoint.y + params.configuration.arrowHeight * 2))
            path.addLine(to: arrowPoint)
        }
        //Bottom arrow
        else if (globalFrame.minY - size.height - params.configuration.arrowHeight - minBottomInset) > 0 {
            let rightSpaceHeight = max(0, screenSize.width - size.width - globalFrame.midX)
            let y = globalFrame.minY - size.height - params.configuration.arrowHeight
            let x = screenSize.width - rightSpaceHeight - size.width - params.configuration.tooltipViewInset * 2
            point = CGPoint(x: max(x, params.configuration.tooltipViewInset), y: y)
            let arrowPoint = CGPoint(x: globalFrame.midX - params.configuration.arrowHeight,
                                     y: globalFrame.minY - params.configuration.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x + params.configuration.arrowHeight,
                                     y: arrowPoint.y + params.configuration.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x + params.configuration.arrowHeight * 2, y: arrowPoint.y))
            path.addLine(to: arrowPoint)
        }
        //Left arrow
        else if (globalFrame.maxX + size.width + params.configuration.arrowHeight + params.configuration.tooltipViewInset) < screenSize.width {
            let bottomSpaceHeight = max(0, screenSize.height - size.height - globalFrame.midY)
            let y = screenSize.height - (bottomSpaceHeight + size.height) - params.configuration.tooltipViewInset * 2
            let x = globalFrame.maxX + params.configuration.arrowHeight
            point = CGPoint(x: x, y: max(y, params.configuration.tooltipViewInset))
            let arrowPoint = CGPoint(x: globalFrame.maxX + params.configuration.arrowHeight,
                                     y: globalFrame.midY - params.configuration.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x - params.configuration.arrowHeight,
                                     y: arrowPoint.y + params.configuration.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: arrowPoint.y + params.configuration.arrowHeight * 2))
            path.addLine(to: arrowPoint)
        }
        //Top arrow
        else {
            let rightSpaceHeight = max(0, screenSize.width - size.width - globalFrame.midX)
            let y = globalFrame.maxY + params.configuration.arrowHeight
            let x = screenSize.width - rightSpaceHeight - size.width - params.configuration.tooltipViewInset * 2
            point = CGPoint(x: max(x, params.configuration.tooltipViewInset), y: y)
            let arrowPoint = CGPoint(x: globalFrame.midX - params.configuration.arrowHeight,
                                     y: globalFrame.maxY + params.configuration.arrowHeight)
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(x: arrowPoint.x + params.configuration.arrowHeight,
                                     y: arrowPoint.y - params.configuration.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x + params.configuration.arrowHeight * 2, y: arrowPoint.y))
            path.addLine(to: arrowPoint)
        }
        triangleShape.path = path
        triangleShape.fillColor = params.configuration.backgroundColor.cgColor
        arrowFrameView.layer.addSublayer(triangleShape)
        return point
    }
    
    @objc private func topButtonAction(_ sender: UIButton) {
        params.configuration.topAction?.completion?()
    }
}

extension InflectiveTooltipViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard params.configuration.isTooltipClosable else { return nil }
        let header = tooltipTableView.dequeueReusableHeaderFooterView(withIdentifier: closeTableHeaderId) as? InflectiveTooltipCloseTableHeader
        header?.delegate = self
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        params.configuration.isTooltipClosable ? UITableView.automaticDimension : CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        params.tooltipItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = params.tooltipItems[indexPath.row]
        let cell = tooltipTableView.dequeueReusableCell(withIdentifier: item.type.reuseId) ?? UITableViewCell()
        switch item.type {
        case .text:
            guard let textTableViewCell = cell as? InflectiveTooltipTextTableViewCell else { return cell }
            textTableViewCell.viewDataItem = (item as? InflectiveTooltipTextItem)
        case .image:
            guard let textTableViewCell = cell as? InflectiveTooltipImageTableViewCell else { return cell }
            textTableViewCell.viewDataItem = (item as? InflectiveTooltipImageItem)
        case .actions:
            guard let textTableViewCell = cell as? InflectiveTooltipActionsTableViewCell else { return cell }
            textTableViewCell.viewDataItem = (item as? InflectiveTooltipActionsItem)
        }
        return cell
    }
}

extension InflectiveTooltipViewController: InflectiveTooltipCloseTableHeaderDelegate {
    public func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
