
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
      
    }
  }
  
  private let trimView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .clear
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.orange.cgColor
    return view
  }()
  
  private let leftDraggableView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .orange
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let rightDraggableView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .orange
    view.translatesAutoresizingMaskIntoConstraints = false
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
  
  private let draggableViewWidth: CGFloat = 15
  
  let dimmingView = DimmingView()
  var leadingConstraint: NSLayoutConstraint?
  var trailingConstraint: NSLayoutConstraint?
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    dimmingView.frame = bounds
    trimView.frame = dimmingView.bounds
    
    leadingConstraint = leftDraggableView.leadingAnchor.constraint(equalTo: trimView.leadingAnchor, constant: 0)
    trailingConstraint = rightDraggableView.trailingAnchor.constraint(equalTo: trimView.trailingAnchor, constant: 0)
    
    NSLayoutConstraint.activate([
      leadingConstraint!,
      leftDraggableView.topAnchor.constraint(equalTo: trimView.topAnchor, constant: 0),
      leftDraggableView.bottomAnchor.constraint(equalTo: trimView.bottomAnchor, constant: 0),
      leftDraggableView.widthAnchor.constraint(equalToConstant: draggableViewWidth),
      rightDraggableView.topAnchor.constraint(equalTo: trimView.topAnchor, constant: 0),
      rightDraggableView.bottomAnchor.constraint(equalTo: trimView.bottomAnchor, constant: 0),
      rightDraggableView.widthAnchor.constraint(equalToConstant: draggableViewWidth),
      trailingConstraint!,
      
      leftMaskView.topAnchor.constraint(equalTo: trimView.topAnchor, constant: 0),
      leftMaskView.bottomAnchor.constraint(equalTo: trimView.bottomAnchor, constant: 0),
      leftMaskView.leadingAnchor.constraint(equalTo: trimView.leadingAnchor, constant: 0),
      leftMaskView.trailingAnchor.constraint(equalTo: leftDraggableView.leadingAnchor, constant: 0)
      ])
  }
  
  private func setup() {
    addSubview(dimmingView)
    addSubview(trimView)
    trimView.addSubview(leftDraggableView)
    trimView.addSubview(rightDraggableView)
    trimView.addSubview(leftMaskView)
    
    setupPanGestures()
  }
  
  private func setupPanGestures() {
    let leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    leftDraggableView.addGestureRecognizer(leftPanGesture)
    let rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    rightDraggableView.addGestureRecognizer(rightPanGesture)
  }
  
  
  //fix me
  @objc func handlePan(_ sender: UIPanGestureRecognizer) {
    guard let view = sender.view else { return }
    
    let isLeftGesture = view == leftDraggableView
    switch sender.state {
      
//    case .began:
//      if isLeftGesture {
//        currentLeftConstraint = leftConstraint!.constant
//      } else {
//        currentRightConstraint = rightConstraint!.constant
//      }
//      updateSelectedTime(stoppedMoving: false)
    case .changed:
      let translation = sender.translation(in: view)
      if isLeftGesture {
        updateLeadingConstraint(with: translation)
      }
//      else {
//        updateRightConstraint(with: translation)
//      }
      layoutIfNeeded()
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
    let maxConstraint = max(rightDraggableView.frame.origin.x - draggableViewWidth - minimumDistanceBetweenDraggableViews, 0)
    let newConstraint = max(min(translation.x, maxConstraint), 0)
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    leadingConstraint?.constant = newConstraint
    CATransaction.commit()
    
    print(translation, maxConstraint, newConstraint)
  }
  
  private var minimumDistanceBetweenDraggableViews: CGFloat {
    return CGFloat(2) * (dimmingView.frame.width / CGFloat(dimmingView.asset.duration.seconds))
  }
  
  var absolutePosition: CGFloat = 0
  
  // Normalized
  var relativePosition: CGFloat {
    get { return absolutePosition / dimmingView.bounds.width }
    set { absolutePosition = newValue }
    }

}
