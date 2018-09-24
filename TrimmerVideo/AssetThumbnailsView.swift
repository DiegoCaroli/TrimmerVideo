//
//  AssetThumbnailsView.swift
//  TrimmerVideo
//
//  Created by Diego Caroli on 19/09/2018.
//  Copyright © 2018 Diego Caroli. All rights reserved.
//

import UIKit
import AVFoundation

class AssetThumbnailsView: UIView {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    var asset: AVAsset! {
        didSet {
            setupAssetImageGenerator(with: asset)
            size = getThumbnailSize(from: asset)
            imageViewsCount = thumbnailsCount
            generateThumbnails()
        }
    }

    private var assetImageGenerator: AVAssetImageGenerator!
    private var frameForTimes = [NSValue]()

    private var totalTimeLength: Int {
        return Int(videoDuration.seconds * Double(videoDuration.timescale))
    }
    
    var videoDuration: CMTime {
        return asset.duration
    }

    var durationSize: CGFloat {
        return bounds.width
    }

    private var size: CGSize = .zero

    private var thumbnailsCount: Int {
        var number = bounds.width / size.width
        number.round(.toNearestOrAwayFromZero)
        return Int(number)
    }

    private var step: Int {
        return totalTimeLength / thumbnailsCount
    }

    var imageViewsCount: Int = 0 {
        didSet {
            (0..<imageViewsCount).forEach { index in
                let thumbView: UIImageView = {
                    let imageView = UIImageView()
                    imageView.frame.size = size
                    imageView.tag = index
                    imageView.backgroundColor = UIColor.black
                    return imageView
                }()
                self.stackView.addArrangedSubview(thumbView)
            }
        }
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

        stackView.frame = bounds
    }

    private func setup() {
        addSubview(stackView)
    }

    private func setupAssetImageGenerator(with asset: AVAsset) {
        assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.requestedTimeToleranceAfter = CMTime.zero
        assetImageGenerator.requestedTimeToleranceBefore = CMTime.zero
        assetImageGenerator.maximumSize = getThumbnailSize(from: asset)
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

        frameForTimes = (0..<thumbnailsCount).map {
            let cmTime = CMTime(value: Int64($0 * step), timescale: Int32(videoDuration.timescale))
            return NSValue(time: cmTime)
        }

        var index = 0
        assetImageGenerator.generateCGImagesAsynchronously(forTimes:
        frameForTimes) { (_, image, _, _, _) in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
                let imageViews = self?.stackView.arrangedSubviews as! [UIImageView]
                imageViews[index].image = UIImage(cgImage: image)
                index += 1
            }
        }
    }

    func getTime(from position: CGFloat) -> CMTime? {
        guard let asset = asset else { return nil }

        let normalizedRatio = getNormalizedPosition(from: position)

        let positionTimeValue = Double(normalizedRatio) * Double(asset.duration.value)

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
}
