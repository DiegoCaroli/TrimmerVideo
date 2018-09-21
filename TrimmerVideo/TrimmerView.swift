
//
//  TrimmerView.swift
//  TrimmerVideo
//
//  Created by Diego Caroli on 19/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol TrimmerViewDelegate: class {
    @objc optional func trimmerDidBeginDragging(
        _ trimmer: TrimmerView,
        with currentTimeTrim: CMTime)

    @objc optional func trimmerDidChangeDraggingPosition(
        _ trimmer: TrimmerView,
        with currentTimeTrim: CMTime)

    @objc optional func trimmerDidEndDragging(
        _ trimmer: TrimmerView,
        with startTime: CMTime,
        endTime: CMTime)
}

@IBDesignable
class TrimmerView: UIView {

    // MARK: IBInspectable
    @IBInspectable var mainColor: UIColor = .orange {
        didSet {
            trimView.layer.borderColor = mainColor.cgColor
            leftDraggableView.backgroundColor = mainColor
            rightDraggableView.backgroundColor = mainColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            trimView.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var minVideoDurationAfterTrimming: CMTime = .zero

    @IBInspectable var isTimePointerVisible: Bool = true

    weak var delegate: TrimmerViewDelegate?

    //MARK: Views
    private lazy var trimView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .clear
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = mainColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var leftDraggableView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var rightDraggableView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()

    private let leftMaskView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .white
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    private let rightMaskView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .white
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    private let timePointerView: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    let assetThumbnailsView: DimmingView = {
        let assetView = DimmingView()
        assetView.translatesAutoresizingMaskIntoConstraints = false
        assetView.isUserInteractionEnabled = true
        return assetView
    }()

    //MARK: Properties
    private let draggableViewWidth: CGFloat = 20
    private let timePointerViewWidth: CGFloat = 2

    private var minimumDistanceBetweenDraggableViews: CGFloat? {
        return assetThumbnailsView
            .getPosition(from: minVideoDurationAfterTrimming)
            .map { $0 + borderWidth }
    }

    var startTime: CMTime? {
        let startPosition = leftDraggableView.frame.maxX - assetThumbnailsView.frame.origin.x

        return assetThumbnailsView.getTime(from: startPosition)
    }

    var endTime: CMTime? {
        let endPosition = rightDraggableView.frame.minX - assetThumbnailsView.frame.origin.x

        return assetThumbnailsView.getTime(from: endPosition)
    }

    // MARK: Constraints
    private(set) lazy var currentLeadingConstraint: CGFloat = 0
    private(set) lazy var currentTrailingConstraint: CGFloat = 0

    private lazy var dimmingViewTopAnchor = assetThumbnailsView.topAnchor
        .constraint(equalTo: topAnchor, constant: 0)
    private lazy var dimmingViewBottomAnchor = assetThumbnailsView.bottomAnchor
        .constraint(equalTo: bottomAnchor, constant: 0)
    private lazy var dimmingViewLeadingAnchor = assetThumbnailsView.leadingAnchor
        .constraint(equalTo: leadingAnchor, constant: draggableViewWidth)
    private lazy var dimmingViewTrailingAnchor = assetThumbnailsView.trailingAnchor
        .constraint(equalTo: trailingAnchor, constant: -draggableViewWidth)

    private lazy var trimViewTopAnchorConstraint = trimView.topAnchor
        .constraint(equalTo: topAnchor, constant: 0)
    private lazy var trimViewBottomAnchorConstraint = trimView.bottomAnchor
        .constraint(equalTo: bottomAnchor, constant: 0)
    private lazy var trimViewLeadingConstraint = trimView.leadingAnchor
        .constraint(equalTo: leadingAnchor, constant: 0)
    private lazy var trimViewTrailingConstraint = trimView.trailingAnchor
        .constraint(equalTo: trailingAnchor, constant: 0)
    private lazy var trimViewWidthContraint = trimView.widthAnchor
        .constraint(greaterThanOrEqualToConstant: draggableViewWidth * 2 + borderWidth)

    private lazy var leftDraggableViewLeadingAnchor = leftDraggableView.leadingAnchor
        .constraint(equalTo: trimView.leadingAnchor, constant: 0)
    private lazy var leftDraggableViewWidthAnchor = leftDraggableView.widthAnchor
        .constraint(equalToConstant: draggableViewWidth)
    private lazy var leftDraggableViewTopAnchor = leftDraggableView.topAnchor
        .constraint(equalTo: trimView.topAnchor, constant: 0)
    private lazy var leftDraggableViewBottomAnchor = leftDraggableView.bottomAnchor
        .constraint(equalTo: trimView.bottomAnchor, constant: 0)

    private lazy var rightDraggableViewTopAnchor = rightDraggableView.topAnchor
        .constraint(equalTo: trimView.topAnchor, constant: 0)
    private lazy var rightDraggableViewBottomAnchor = rightDraggableView.bottomAnchor
        .constraint(equalTo: trimView.bottomAnchor, constant: 0)
    private lazy var rightDraggableViewTrailingAnchor = rightDraggableView.trailingAnchor
        .constraint(equalTo: trimView.trailingAnchor, constant: 0)
    private lazy var rightDraggableViewWidthAnchor = rightDraggableView.widthAnchor
        .constraint(equalToConstant: draggableViewWidth)

    private lazy var leftMaskViewTopAnchor = leftMaskView.topAnchor
        .constraint(equalTo: trimView.topAnchor, constant: 0)
    private lazy var leftMaskViewBottomAnchor = leftMaskView.bottomAnchor
        .constraint(equalTo: trimView.bottomAnchor, constant: 0)
    private lazy var leftMaskViewLeadingAnchor = leftMaskView.leadingAnchor
        .constraint(equalTo: leadingAnchor, constant: 0)
    private lazy var leftMaskViewTrailingAnchor = leftMaskView.trailingAnchor
        .constraint(equalTo: leftDraggableView.leadingAnchor, constant: 0)

    private lazy var rightMaskViewTopAnchor = rightMaskView.topAnchor
        .constraint(equalTo: topAnchor, constant: 0)
    private lazy var rightMaskViewBottomAnchor = rightMaskView.bottomAnchor
        .constraint(equalTo: bottomAnchor, constant: 0)
    private lazy var rightMaskViewTrailingAnchor = rightMaskView.trailingAnchor
        .constraint(equalTo: trailingAnchor, constant: 0)
    private lazy var rightMaskViewLeadingAnchor = rightMaskView.leadingAnchor
        .constraint(equalTo: rightDraggableView.trailingAnchor, constant: 0)

    private lazy var timePointerViewWidthgAnchor = timePointerView.widthAnchor
        .constraint(equalToConstant: timePointerViewWidth)
    private lazy var timePointerViewHeightAnchor = timePointerView.heightAnchor
        .constraint(equalToConstant: bounds.height - timePointerViewWidth * 2)
    private lazy var timePointerViewTopAnchor = timePointerView.topAnchor
        .constraint(equalTo: topAnchor, constant: borderWidth)
    private lazy var timePointerViewLeadingAnchor = timePointerView.leadingAnchor
        .constraint(equalTo: leftDraggableView.trailingAnchor, constant: 0)

    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        setup()

        trimViewLeadingConstraint.priority = .defaultHigh
        trimViewTrailingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            dimmingViewTopAnchor,
            dimmingViewBottomAnchor,
            dimmingViewLeadingAnchor,
            dimmingViewTrailingAnchor,

            trimViewTopAnchorConstraint,
            trimViewBottomAnchorConstraint,
            trimViewLeadingConstraint,
            trimViewTrailingConstraint,

            trimViewWidthContraint,

            leftDraggableViewLeadingAnchor,
            leftDraggableViewWidthAnchor,
            leftDraggableViewTopAnchor,
            leftDraggableViewBottomAnchor,

            rightDraggableViewTopAnchor,
            rightDraggableViewBottomAnchor,
            rightDraggableViewTrailingAnchor,
            rightDraggableViewWidthAnchor,

            leftMaskViewTopAnchor,
            leftMaskViewBottomAnchor,
            leftMaskViewLeadingAnchor,
            leftMaskViewTrailingAnchor,

            rightMaskViewTopAnchor,
            rightMaskViewBottomAnchor,
            rightMaskViewLeadingAnchor,
            rightMaskViewTrailingAnchor,
            ])
    }

    // MARK: Setups views
    private func setup() {
        backgroundColor = UIColor.clear

        addSubview(assetThumbnailsView)
        addSubview(trimView)

        addSubview(leftDraggableView)
        addSubview(rightDraggableView)
        addSubview(leftMaskView)
        addSubview(rightMaskView)

        setupTimePointer()
        setupPanGestures()
    }

    private func setupTimePointer() {
        if isTimePointerVisible {
            addSubview(timePointerView)

            NSLayoutConstraint.activate([
                timePointerViewHeightAnchor,
                timePointerViewWidthgAnchor,
                timePointerViewTopAnchor,
                timePointerViewLeadingAnchor
                ])
        } else {
            timePointerView.removeFromSuperview()

            NSLayoutConstraint.deactivate([
                timePointerViewHeightAnchor,
                timePointerViewWidthgAnchor,
                timePointerViewTopAnchor,
                timePointerViewLeadingAnchor
                ])
        }
    }

    //MARK: Gestures
    private func setupPanGestures() {
        let leftPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan))
        leftDraggableView.addGestureRecognizer(leftPanGesture)

        let rightPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan))
        rightDraggableView.addGestureRecognizer(rightPanGesture)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }

        let isLeftGesture = (view == leftDraggableView)
        switch sender.state {

        case .began:
            if isLeftGesture {
                currentLeadingConstraint = trimViewLeadingConstraint.constant
            } else {
                currentTrailingConstraint = trimViewTrailingConstraint.constant
            }

            if let start = startTime {
                delegate?.trimmerDidBeginDragging?(self, with: start)
            }

        case .changed:
            let translation = sender.translation(in: view)
            if isLeftGesture {
                updateLeadingConstraint(with: translation)
            } else {
                updateTrailingConstraint(with: translation)
            }

            UIView.animate(withDuration: 0.1) {
                self.layoutIfNeeded()
            }

            if isLeftGesture, let startTime = startTime {
                delegate?.trimmerDidChangeDraggingPosition?(self, with: startTime)
                timePointerView.isHidden = true
            } else if let endTime = endTime {
                delegate?.trimmerDidChangeDraggingPosition?(self, with: endTime)
                timePointerView.isHidden = true
            }

        case .cancelled, .failed, .ended:
            if let startTime = startTime, let endTime = endTime {
                delegate?.trimmerDidEndDragging?(
                    self,
                    with: startTime,
                    endTime: endTime)

                timePointerView.isHidden = false
                timePointerViewLeadingAnchor.constant = 0
            }

        default:
            break
        }
    }

    //MARK: Methods
    private func updateLeadingConstraint(with translation: CGPoint) {

        guard let minDistance = minimumDistanceBetweenDraggableViews
            else { return }

        let maxConstraint = self.bounds.width
            - (draggableViewWidth * 2)
            - minDistance

        assert(maxConstraint >= 0)

        let newPosition = clamp(
            currentLeadingConstraint + translation.x,
            0, maxConstraint)

        trimViewLeadingConstraint.constant = newPosition
    }

    private func updateTrailingConstraint(with translation: CGPoint) {

        guard let minDistance = minimumDistanceBetweenDraggableViews
            else { return }

        let maxConstraint = self.bounds.width
            - (draggableViewWidth * 2)
            - minDistance

        let newPosition = clamp(
            currentTrailingConstraint + translation.x,
            -maxConstraint, 0)

        trimViewTrailingConstraint.constant = newPosition
    }

    //FIXME: Something
    public func seek(to time: CMTime) {
        guard let newPosition = assetThumbnailsView.getPosition(from: time)
            else { return }

        assert(assetThumbnailsView.getNormalizedTime(from: time)! < 1.1)

        let offsetPosition = assetThumbnailsView
            .convert(CGPoint(x: newPosition, y: 0), to: trimView)
            .x - draggableViewWidth

//        let offsetPosition = newPosition
//            - leftDraggableView.frame.maxX

        let maxPosition = rightDraggableView.frame.minX
            - leftDraggableView.frame.maxX
            - timePointerView.frame.width

        let clampedPosition = clamp(offsetPosition, 0, maxPosition)
        timePointerViewLeadingAnchor.constant = CGFloat(clampedPosition)
        layoutIfNeeded()
    }

    func resetTimePointer() {
        timePointerViewLeadingAnchor.constant = 0
    }

}

private func clamp<T: Comparable>(_ number: T, _ minimum: T, _ maximum: T) -> T {
    return min(maximum, max(minimum, number))
}
