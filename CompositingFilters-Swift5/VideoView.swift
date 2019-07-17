//
//  VideoView.swift
//  CompositingFilters-Swift5
//
//  Created by Austin Kwong on 7/16/19.
//  Copyright © 2019 Austin Kwong. All rights reserved.
//

import AVKit
import Foundation
import UIKit

class VideoView: UIView {

    private let assetUrl = Bundle.main.url(forResource: "7B00BF88-F57B-4E65-B1C6-94A982AC7FD8-0", withExtension: "mov")
    private var player: AVPlayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let url = assetUrl else { return }

        self.player = AVPlayer(url: url)

        guard let player = player else { return }
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        self.player?.play()

        // Loop Video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
}
