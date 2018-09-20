//
//  ViewController.swift
//  TrimmerVideo
//
//  Created by Diego Caroli on 19/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet var dimmingView: TrimmerView!
  @IBOutlet var playerView: UIView!
  private var player: AVPlayer!
  
  var asset: AVAsset!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let path = Bundle(for: ViewController.self).path(forResource: "IMG_0065", ofType: "m4v") else {
      fatalError("impossible load video")
    }
    let fileURL = URL(fileURLWithPath: path, isDirectory: false)
    asset = AVAsset(url: fileURL)
    
//             asset = AVAsset(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
    
    setupPlayerLayer(for: fileURL)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    dimmingView.assetThumbnailsView.asset = asset
  }
  
  private func setupPlayerLayer(for url: URL) {
    let playerLayer = AVPlayerLayer()
    playerLayer.frame = playerView.bounds
    player = AVPlayer(url: url)
    
    player.actionAtItemEnd = .none
    playerLayer.player = player
    playerView.layer.addSublayer(playerLayer)
  }
  
}

