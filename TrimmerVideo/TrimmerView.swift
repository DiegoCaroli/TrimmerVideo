
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
  
  private let draggableViewWidth: CGFloat = 20
  
  var dimmingView: DimmingView = {
    let dimmingView = DimmingView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.backgroundColor = UIColor.green
    dimmingView.isUserInteractionEnabled = true
    return dimmingView
  }()
  
  private(set) var currentLeadingConstraint: CGFloat = 0
  private(set) var currentTrailingConstraint: CGFloat = 0
  
  private(set) var leadingConstraintView: NSLayoutConstraint?
  
  private var minimumDistanceBetweenDraggableViews: CGFloat {
    return CGFloat(1) * (dimmingView.frame.width / CGFloat(dimmingView.asset.duration.seconds))
  }
  
  private lazy var dimmingViewTopAnchor = dimmingView.topAnchor
    .constraint(equalTo: topAnchor, constant: 0)
  private lazy var dimmingViewBottomAnchor = dimmingView.bottomAnchor
    .constraint(equalTo: bottomAnchor, constant: 0)
  private lazy var dimmingViewLeadingAnchor = dimmingView.leadingAnchor
    .constraint(equalTo: leadingAnchor, constant: draggableViewWidth)
  private lazy var dimmingViewTrailingAnchor = dimmingView.trailingAnchor
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
    .constraint(equalTo: leadingAnchor, constant: 0)
  private lazy var leftDraggableViewWidthAnchor = leftDraggableView.widthAnchor
    .constraint(equalToConstant: draggableViewWidth)
  private lazy var leftDraggableViewTopAnchor = leftDraggableView.topAnchor
    .constraint(equalTo: topAnchor, constant: 0)
  private lazy var leftDraggableViewBottomAnchor = leftDraggableView.bottomAnchor
    .constraint(equalTo: bottomAnchor, constant: 0)
  
  private lazy var rightDraggableViewTopAnchor = rightDraggableView.topAnchor
    .constraint(equalTo: trimView.topAnchor, constant: 0)
  private lazy var rightDraggableViewBottomAnchor = rightDraggableView.bottomAnchor
    .constraint(equalTo: trimView.bottomAnchor, constant: 0)
  private lazy var rightDraggableViewTrailingAnchor = rightDraggableView.trailingAnchor
    .constraint(equalTo: trimView.trailingAnchor, constant: 0)
  private lazy var rightDraggableViewWidthAnchor = rightDraggableView.widthAnchor
    .constraint(equalToConstant: draggableViewWidth)
  
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
      rightDraggableViewWidthAnchor
      ])
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    

  }
  
  private func setup() {
    addSubview(dimmingView)
    addSubview(trimView)

    addSubview(leftDraggableView)
    addSubview(rightDraggableView)
    //    trimView.addSubview(leftDraggableView)
    //    trimView.addSubview(rightDraggableView)
    //    trimView.addSubview(leftMaskView)
    //    trimView.addSubview(rightMaskView)
    
    setupPanGestures()
  }
  
  private func setupPanGestures() {
    let leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    leftDraggableView.addGestureRecognizer(leftPanGesture)
    let rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    rightDraggableView.addGestureRecognizer(rightPanGesture)
  }
  
  @objc func handlePan(_ sender: UIPanGestureRecognizer) {
    guard let view = sender.view else { return }
    
    let isLeftGesture = view == leftDraggableView
    switch sender.state {
      
    case .began:
      if isLeftGesture {
        currentLeadingConstraint = trimViewLeadingConstraint.constant
      } else {
        currentTrailingConstraint = trimViewTrailingConstraint.constant
      }
    //      updateSelectedTime(stoppedMoving: false)
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
//      if let startTime = startTime, isLeftGesture {
//        seek(to: startTime)
//      } else if let endTime = endTime {
//        seek(to: endTime)
//      }
//      updateSelectedTime(stoppedMoving: false)
      
//    case .cancelled, .ended, .failed:
//      updateSelectedTime(stoppedMoving: true)
    default: break
    }
  }
  
  private func updateLeadingConstraint(with translation: CGPoint) {
    let maxConstraint = max(0, rightDraggableView.frame.origin.x - draggableViewWidth)
    let newPosition = min(max(0, currentLeadingConstraint + translation.x), maxConstraint)

    trimViewLeadingConstraint.constant = newPosition
  }
  
  private func updateTrailingConstraint(with translation: CGPoint) {
    let maxConstraint = min(0, 2 * draggableViewWidth - frame.width + leftDraggableView.frame.origin.x)
    let newPosition = max(min(0, currentTrailingConstraint + translation.x), maxConstraint)
    
    trimViewTrailingConstraint.constant = newPosition
  }
  
}
