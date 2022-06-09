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
    /*
     combine:
     ObservableObject is a type with publisher that emits before has changed
     */
    let player = AVPlayer()
    /*
     combine:
     @Published is a type that publishes a property marked with an attribute.
     @Published property wrapper is added to any properties inside an observed object that should cause views to update when they change
     */
    @Published var isInPipMode: Bool = false
    @Published var isPlaying = false
    @Published var clockText : String = "Hello world"
    @Published var timeOffset : TimeInterval = 0
    
    init() {
        player.isMuted = true
        player.allowsExternalPlayback = true
    }
    
    func setCurrentItem(_ item: AVPlayerItem) {
        player.replaceCurrentItem(with: item)
    }
}
