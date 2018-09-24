//
//  TrimmingController.swift
//  TrimmerVideo
//
//  Created by Diego Caroli on 24/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import UIKit
import AVFoundation

class TrimmingController: NSObject {
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var trimmerView: TrimmerView!{
        didSet {
            trimmerView.delegate = self
        }
    }
    
    private var player: AVPlayer?
    private var isPlaying = false
    private var playbackTimeCheckerTimer: Timer?
    
    func setupPlayerLayer(for url: URL, with playerView: UIView) {
        let playerLayer = AVPlayerLayer()
        playerLayer.frame = playerView.bounds
        player = AVPlayer(url: url)
        
        playerLayer.player = player
        playerView.layer.addSublayer(playerLayer)
        playerView.addSubview(playPauseButton)
    }
    
    func generateThumbnails(for asset: AVAsset) {
        trimmerView.assetThumbnailsView.asset = asset
    }
    
    @IBAction func playPauseButtonPressed() {
        if !isPlaying {
            player?.play()
            startPlaybackTimeChecker()
            playPauseButton.setTitle("Pause", for: .normal)
            isPlaying = true
        } else {
            player?.pause()
            stopPlaybackTimeChecker()
            playPauseButton.setTitle("Play", for: .normal)
            isPlaying = false
        }
    }
    
    func pause() {
        player?.pause()
        stopPlaybackTimeChecker()
        playPauseButton.setTitle("Play", for: .normal)
        isPlaying = false
        trimmerView.resetTimePointer()
    }
    
    func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }
    
    func stopPlaybackTimeChecker() {
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }
    
    @objc func onPlaybackTimeChecker() {
        
        guard let startTime = trimmerView.startTime,
            let endTime = trimmerView.endTime,
            let player = player else {
                return
        }
        
        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)
        
        if playBackTime >= endTime {
            player.seek(to: startTime,
                        toleranceBefore: CMTime.zero,
                        toleranceAfter: CMTime.zero)
            trimmerView.seek(to: startTime)
            pause()
        }
    }
    
}

//MARK: TrimmerViewDelegate
extension TrimmingController: TrimmerViewDelegate {
    func trimmerDidChangeDraggingPosition(
        _ trimmer: TrimmerView,
        with currentTimePointer: CMTime) {
        
        player?.pause()
        playPauseButton.isHidden = true
        
        assert(currentTimePointer.seconds >= 0)
        
        assert(currentTimePointer.seconds <= trimmerView.assetThumbnailsView.asset.duration.seconds)
        
        player?.seek(
            to: currentTimePointer,
            toleranceBefore: .zero,
            toleranceAfter: .zero)
    }
    
    func trimmerDidEndDragging(
        _ trimmer: TrimmerView,
        with startTime: CMTime,
        endTime: CMTime) {
        
        playPauseButton.isHidden = false
        
        assert(startTime.seconds >= 0)
        
        assert(startTime.seconds <= trimmerView.assetThumbnailsView.asset.duration.seconds)
        
        assert(endTime.seconds >= 0)
        
        assert(endTime.seconds <= trimmerView.assetThumbnailsView.asset.duration.seconds)
        
        print(startTime, endTime)
    }
}

