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

    @IBOutlet var playerView: UIView!
   
    @IBOutlet var trim: TrimmingController!
    
    var asset: AVAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerView.backgroundColor = UIColor.clear
        
        guard let path = Bundle(for: ViewController.self)
            .path(forResource: "IMG_0065", ofType: "m4v")
            else { fatalError("impossible load video") }

        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        asset = AVAsset(url: fileURL)

        //             asset = AVAsset(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)

        trim.setupPlayerLayer(for: fileURL, with: playerView)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        trim.generateThumbnails(for: asset)
    }

}
