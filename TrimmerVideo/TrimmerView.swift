
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
  
  private let draggableViewWidth: CGFloat = 20
  
  let dimmingView = DimmingView()
  private(set) var leadingConstraint: NSLayoutConstraint?
  private(set) var trailingConstraint: NSLayoutConstraint?
  private(set) var currentLeadingConstraint: CGFloat = 0
  private(set) var currentTrailingConstraint: CGFloat = 0
  
  private var minimumDistanceBetweenDraggableViews: CGFloat {
    return CGFloat(1) * (dimmingView.frame.width / CGFloat(dimmingView.asset.duration.seconds))
  }
  
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
      leftMaskView.trailingAnchor.constraint(equalTo: leftDraggableView.leadingAnchor, constant: 0),
      rightMaskView.topAnchor.constraint(equalTo: trimView.topAnchor, constant: 0),
      rightMaskView.bottomAnchor.constraint(equalTo: trimView.bottomAnchor, constant: 0),
      rightMaskView.leadingAnchor.constraint(equalTo: rightDraggableView.trailingAnchor, constant: 0),
      rightMaskView.trailingAnchor.constraint(equalTo: trimView.trailingAnchor, constant: 0)
      ])
  }
  
  private func setup() {
    addSubview(dimmingView)
    addSubview(trimView)
    trimView.addSubview(leftDraggableView)
    trimView.addSubview(rightDraggableView)
    trimView.addSubview(leftMaskView)
    trimView.addSubview(rightMaskView)
    
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
      
    case .began:
      if isLeftGesture {
        guard let leadingConstraint = leadingConstraint else {
          assertionFailure("leading constraint must be setup")
          return
        }
        currentLeadingConstraint = leadingConstraint.constant
      } else {
        guard let trailingConstraint = trailingConstraint else {
          assertionFailure("trailing constraint must be setup")
          return
        }
        currentTrailingConstraint = trailingConstraint.constant
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
    let maxConstraint = max(0, rightDraggableView.frame.origin.x - draggableViewWidth - minimumDistanceBetweenDraggableViews)
    let newPosition = min(max(0, currentLeadingConstraint + translation.x), maxConstraint)

    guard let leadingConstraint = leadingConstraint else {
      assertionFailure("leading constraint must be setup")
      return
    }
    leadingConstraint.constant = newPosition
  }
  
  private func updateTrailingConstraint(with translation: CGPoint) {
    let maxConstraint = min(0, 2 * draggableViewWidth - frame.width + leftDraggableView.frame.origin.x + minimumDistanceBetweenDraggableViews)
    let newPosition = max(min(0, currentTrailingConstraint + translation.x), maxConstraint)
    
    guard let trailingConstraint = trailingConstraint else {
      assertionFailure("trailing constraint must be setup")
      return
    }
    trailingConstraint.constant = newPosition
  }
  
}
