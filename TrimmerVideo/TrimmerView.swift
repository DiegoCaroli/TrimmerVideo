
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
  
  @IBInspectable var mainColor: UIColor = UIColor.black
  @IBInspectable var handColor: UIColor = UIColor.black
  
  private let borderView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .clear
    return view
  }()
  var borderWidth: CGFloat = 20
  
  
  private let leftPanView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .orange
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let rightPanView: UIView = {
    let view = UIView()
    view.frame = .zero
    view.backgroundColor = .orange
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
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
    borderView.frame = dimmingView.bounds
    
    leadingConstraint = leftPanView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 0)
    trailingConstraint = rightPanView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: 0)
    
    NSLayoutConstraint.activate([
      leadingConstraint!,
      leftPanView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 0),
      leftPanView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 0),
      leftPanView.widthAnchor.constraint(equalToConstant: borderWidth),
      rightPanView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 0),
      rightPanView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 0),
      rightPanView.widthAnchor.constraint(equalToConstant: borderWidth),
      trailingConstraint!
      ])
  }
  
  private func setup() {
    addSubview(dimmingView)
    addSubview(borderView)
    borderView.addSubview(leftPanView)
    borderView.addSubview(rightPanView)
    
    borderView.layer.borderWidth = 2
    borderView.layer.borderColor = UIColor.orange.cgColor
    
    setupPanGestures()
  }
  
  private func setupPanGestures() {
    let leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    leftPanView.addGestureRecognizer(leftPanGesture)
    let rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    rightPanView.addGestureRecognizer(rightPanGesture)
  }
  
  
  //fix me
  @objc func handlePan(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: sender.view)
    
    print(rightPanView.frame)
    if translation.x >= 0 &&
      translation.x <= rightPanView.frame.minX {
      leadingConstraint?.constant += translation.x
    }
    
    sender.setTranslation(.zero, in: sender.view)
  }

}
