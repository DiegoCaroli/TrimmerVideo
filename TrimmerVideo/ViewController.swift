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
    private var playbackTimeCheckerTimer: Timer?


    var asset: AVAsset!
    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.backgroundColor = UIColor.clear
        dimmingView.delegate = self

        guard let path = Bundle(for: ViewController.self)
            .path(forResource: "IMG_0065", ofType: "m4v")
            else { fatalError("impossible load video") }

        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        asset = AVAsset(url: fileURL)

        //             asset = AVAsset(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)

        setupPlayerLayer(for: fileURL)
        player?.seek(to: CMTime(value: 0, timescale: 100000000))
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
            startPlaybackTimeChecker()
            playButton.setTitle("Pause", for: .normal)
            isPlaying = true
        } else {
            player?.pause()
            stopPlaybackTimeChecker()
            playButton.setTitle("Play", for: .normal)
            isPlaying = false
        }
    }

    func pause() {
        player?.pause()
        stopPlaybackTimeChecker()
        playButton.setTitle("Play", for: .normal)
        isPlaying = false
        dimmingView.resetTimePointer()
    }

    func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(ViewController.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }

    func stopPlaybackTimeChecker() {
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {

        guard let startTime = dimmingView.startTime,
            let endTime = dimmingView.endTime,
            let player = player else {
                return
        }

        let playBackTime = player.currentTime()
        dimmingView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime,
                        toleranceBefore: CMTime.zero,
                        toleranceAfter: CMTime.zero)
            dimmingView.seek(to: startTime)
            pause()
        }
    }

}

//MARK: TrimmerViewDelegate
extension ViewController: TrimmerViewDelegate {
    func trimmerDidChangeDraggingPosition(
        _ trimmer: TrimmerView,
        with currentTimePointer: CMTime) {

        player?.pause()
        playButton.isHidden = true

        assert(currentTimePointer.seconds >= 0)

        assert(currentTimePointer.seconds <= dimmingView.assetThumbnailsView.asset.duration.seconds)

        player?.seek(
            to: currentTimePointer,
            toleranceBefore: .zero,
            toleranceAfter: .zero)
    }

    func trimmerDidEndDragging(
        _ trimmer: TrimmerView,
        with startTime: CMTime,
        endTime: CMTime) {

        playButton.isHidden = false

        assert(startTime.seconds >= 0)

        assert(startTime.seconds <= dimmingView.assetThumbnailsView.asset.duration.seconds)

        assert(endTime.seconds >= 0)

        assert(endTime.seconds <= dimmingView.assetThumbnailsView.asset.duration.seconds)

        print(startTime, endTime)
    }
}
