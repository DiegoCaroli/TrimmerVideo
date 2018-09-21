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
  @IBOutlet var playButton: UIButton!
  private var player: AVPlayer?
  private var isPlaying = false
  
  
  var asset: AVAsset!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playerView.backgroundColor = UIColor.clear
    dimmingView.delegate = self
    
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
    
    player?.actionAtItemEnd = .none
    playerLayer.player = player
    playerView.layer.addSublayer(playerLayer)
    playerView.addSubview(playButton)
  }
  
  
  @IBAction func playPauseButtonPressed() {
    if !isPlaying {
      player?.play()
      playButton.setTitle("Pause", for: .normal)
      isPlaying = true
    } else {
      player?.pause()
      playButton.setTitle("Play", for: .normal)
      isPlaying = false
    }
  }
  
}

//MARK: TrimmerViewDelegate
extension ViewController: TrimmerViewDelegate {

  func beginDraggableTrimmer(with currentTimePointer: CMTime) {
    player?.pause()
    playButton.isHidden = true
    player?.seek(to: currentTimePointer,
                 toleranceBefore: CMTime.zero,
                 toleranceAfter: CMTime.zero)
  }
  
  func finishDraggableTrimmer(with startTime: CMTime, endTime: CMTime) {
    playButton.isHidden = false
    print(startTime, endTime)
  }
  
}
