//
//  CustomPlayerWithControls.swift
//  BTCompTest
//
//  Created by blacktea on 2022/6/7.
//

import SwiftUI
import AVKit

struct CustomPlayerWithControls: View {
    @StateObject private var playerVM = PlayerViewModel()
    @State private var media: Media = .init(title: "First video", url: Bundle.main.path(forResource: "test", ofType: "mp4") ?? "")
    
    init() {
        // we need this to use Picture in Picture
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                CustomVideoPlayer(playerVM: playerVM)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding()
            Text(playerVM.clockText)
                .font(.system(size: 34)).multilineTextAlignment(.center)
            Button(action: {
                withAnimation {
                    playerVM.isInPipMode.toggle()
                }
            }, label: {
                if playerVM.isInPipMode {
                    Label("Stop PiP", systemImage: "pip.exit")
                } else {
                    Label("Start PiP", systemImage: "pip.enter")
                }
            })
            .padding()
        }
        .padding()
        .onAppear {
            playerVM.setCurrentItem(media.asPlayerItem)
            playerVM.player.play()
            // 直接启动画中画
            self.launchPInP()
        }
        .onDisappear {
            playerVM.player.pause()
        }
    }
    
    func launchPInP() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { Timer in
            playerVM.isInPipMode.toggle()
        }
    }
}
