
//
//  TrimmerView.swift
//  TrimmerVideo
//
//  Created by Diego Caroli on 19/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import UIKit

@IBDesignable
class TrimmerView: UIView {
  
  @IBInspectable var mainColor: UIColor = UIColor.black {
    didSet {
      //update color, customisation
    }
  }
  
  @IBInspectable var minDuration: Int = 0
  
  private let borderWidth: CGFloat = 2
  
  private let trimView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .clear
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.orange.cgColor
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isUserInteractionEnabled = true
    return view
  }()
  
  private let leftDraggableView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .orange
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isUserInteractionEnabled = true
    return view
  }()
  
  private let rightDraggableView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .orange
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
  
  private let draggableViewWidth: CGFloat = 20
  private let timePointerViewWidth: CGFloat = 2
  
  var assetThumbnailsView: DimmingView = {
    let assetView = DimmingView()
    assetView.translatesAutoresizingMaskIntoConstraints = false
    assetView.isUserInteractionEnabled = true
    return assetView
  }()
  
  private(set) lazy var currentLeadingConstraint: CGFloat = 0
  private(set) lazy var currentTrailingConstraint: CGFloat = 0
  
  private var minimumDistanceBetweenDraggableViews: CGFloat {
    return CGFloat(minDuration) * (assetThumbnailsView.frame.width / CGFloat(assetThumbnailsView.asset.duration.seconds))
  }
  
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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setup()
    
    NSLayoutConstraint.activate([
      dimmingViewTopAnchor,
      dimmingViewBottomAnchor,
      dimmingViewLeadingAnchor,
      dimmingViewTrailingAnchor,
      
      trimViewTopAnchorConstraint,
      trimViewBottomAnchorConstraint,
      trimViewLeadingConstraint,
      trimViewTrailingConstraint,
      
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
      
      timePointerViewHeightAnchor,
      timePointerViewWidthgAnchor,
      timePointerViewTopAnchor,
      timePointerViewLeadingAnchor
      ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  private func setup() {
    backgroundColor = UIColor.clear
    
    addSubview(assetThumbnailsView)
    addSubview(trimView)
    
    addSubview(leftDraggableView)
    addSubview(rightDraggableView)
    addSubview(leftMaskView)
    addSubview(rightMaskView)
    
    addSubview(timePointerView)
    
    setupPanGestures()
  }
  
  private func setupPanGestures() {
    let leftPanGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePan))
    leftDraggableView.addGestureRecognizer(leftPanGesture)
    let rightPanGesture = UIPanGestureRecognizer(target: self,
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
      
    default:
      break
    }
  }
  
  private func updateLeadingConstraint(with translation: CGPoint) {
    let maxConstraint = max(0, rightDraggableView.frame.origin.x
      - draggableViewWidth - minimumDistanceBetweenDraggableViews)
    let newPosition = min(max(0, currentLeadingConstraint + translation.x),
                          maxConstraint)
    
    trimViewLeadingConstraint.constant = newPosition
  }
  
  private func updateTrailingConstraint(with translation: CGPoint) {
    let maxConstraint = min(0, 2 * draggableViewWidth - frame.width +
      leftDraggableView.frame.origin.x + minimumDistanceBetweenDraggableViews)
    let newPosition = max(min(0, currentTrailingConstraint + translation.x),
                          maxConstraint)
    
    trimViewTrailingConstraint.constant = newPosition
  }
  
}
