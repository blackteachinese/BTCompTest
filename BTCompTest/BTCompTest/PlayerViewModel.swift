//
//  PlayerViewModel.swift
//  BTCompTest
//
//  Created by blacktea on 2022/6/7.
//

import SwiftUI
import AVKit
import Combine

struct Media: Identifiable {
    let id = UUID()
    let title: String
    let url: String
    
    var asPlayerItem: AVPlayerItem {
        AVPlayerItem(url: URL(fileURLWithPath: url))
    }
}

final class PlayerViewModel: ObservableObject {
    let player = AVPlayer()
    @Published var clockText : String = "Hello world"
    @Published var isInPipMode: Bool = false
    @Published var isPlaying = false
    
    private var subscriptions: Set<AnyCancellable> = []
    
    deinit {

    }
    
    init() {
        player.isMuted = true
        player.allowsExternalPlayback = true
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)

    }
    
    func setCurrentItem(_ item: AVPlayerItem) {
        player.replaceCurrentItem(with: item)
    }
}
