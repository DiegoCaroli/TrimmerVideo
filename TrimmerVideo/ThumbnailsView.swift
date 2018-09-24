//
//  ThumbnailsView.swift
//  TrimmerVideo
//
//  Created by Diego Caroli on 19/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import UIKit
import AVFoundation

class ThumbnailsView: UIView {

    private let thumbsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    var asset: AVAsset! {
        didSet {
            thumbnailSize = getThumbnailSize(from: asset)
            regenerateThumbViews(count: thumbnailsCount)
            generateThumbnails()
        }
    }

    private lazy var assetImageGenerator: AVAssetImageGenerator = setupAssetImageGenerator(with: asset)
    
    private lazy var thumbnailSize: CGSize = getThumbnailSize(from: asset)

    private var totalTimeLength: Int {
        return Int(videoDuration.seconds * Double(videoDuration.timescale))
    }
    
    var videoDuration: CMTime {
        return asset.duration
    }

    var durationSize: CGFloat {
        return bounds.width
    }

    private var thumbnailsCount: Int {
        var number = bounds.width / thumbnailSize.width
        number.round(.toNearestOrAwayFromZero)
        return Int(number)
    }

    private var videoStep: Int {
        return totalTimeLength / thumbnailsCount
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        thumbsStackView.frame = bounds
    }

    private func setup() {
        addSubview(thumbsStackView)
    }

    private func setupAssetImageGenerator(with asset: AVAsset) -> AVAssetImageGenerator {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceAfter = CMTime.zero
        generator.requestedTimeToleranceBefore = CMTime.zero
        generator.maximumSize = getThumbnailSize(from: asset)
        return generator
    }

    private func getThumbnailSize(from asset: AVAsset) -> CGSize {
        guard let track = asset.tracks(withMediaType: AVMediaType.video).first
            else { fatalError() }
        let assetSize = track.naturalSize.applying(track.preferredTransform)

        let aspetWidth = bounds.width / assetSize.width
        let aspetHeight = bounds.height / assetSize.height
        let ascpectRatio = min(aspetWidth, aspetHeight)

        return CGSize(width: assetSize.width * ascpectRatio,
                      height: assetSize.height * ascpectRatio)
    }

    private func generateThumbnails() {
        assetImageGenerator.cancelAllCGImageGeneration()

        let frameForTimes: [NSValue] = (0..<thumbnailsCount).map {
            let cmTime = CMTime(value: Int64($0 * videoStep),
                                timescale: Int32(videoDuration.timescale))
            return NSValue(time: cmTime)
        }

        assert(frameForTimes.count == thumbsStackView.arrangedSubviews.count)
        
        DispatchQueue.global(qos: .userInitiated).async { [assetImageGenerator] in
            var index = 0
            assetImageGenerator.generateCGImagesAsynchronously(forTimes:
            frameForTimes) { (_, image, _, _, _) in
                guard let image = image else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let imageViews = self?.thumbsStackView
                        .arrangedSubviews as? [UIImageView] else { return }
                    imageViews[index].image = UIImage(cgImage: image)
                    index += 1
                }
            }
        }
    }

    func getTime(from position: CGFloat) -> CMTime? {
        guard let asset = asset else { return nil }

        let normalizedRatio = getNormalizedPosition(from: position)

        let positionTimeValue = Double(normalizedRatio)
            * Double(asset.duration.value)

        return CMTime(
            value: Int64(positionTimeValue),
            timescale: asset.duration.timescale)
    }

    func getNormalizedTime(from time: CMTime) -> CGFloat? {
        guard let asset = asset else { return nil }

        let result = CGFloat(time.seconds / asset.duration.seconds)
        assert(result < 1.05)
        return result
    }

    func getPosition(from time: CMTime) -> CGFloat? {
        return getNormalizedTime(from: time)
            .map { $0 * durationSize }
    }

    func getNormalizedPosition(from position: CGFloat) -> CGFloat {
        return max(min(1, position / durationSize), 0)
    }
    
    func regenerateThumbViews(count: Int) {
        
        thumbsStackView.arrangedSubviews
            .forEach(thumbsStackView.removeArrangedSubview)
        
        (0..<count).map { _ in
            let imageView = UIImageView()
            imageView.frame.size = thumbnailSize
            imageView.backgroundColor = UIColor.black
            return imageView
            }.forEach(thumbsStackView.addArrangedSubview)
    }
}
