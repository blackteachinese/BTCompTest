//
//  PlayerView.swift
//  BTCompTest
//
//  Created by blacktea on 2022/6/7.
//

import SwiftUI
import AVKit
import Combine
import SnapKit

class PlayerView: UIView {
    
    // Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

struct CustomVideoPlayer: UIViewRepresentable {
    @ObservedObject var playerVM: PlayerViewModel
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
        private let parent: CustomVideoPlayer
        private var controller: AVPictureInPictureController?
        private var cancellable: AnyCancellable?
        var clockLabel : UILabel
        init(_ parent: CustomVideoPlayer) {
            self.parent = parent
            self.clockLabel = UILabel()
            self.clockLabel.textAlignment = NSTextAlignment.center
            self.clockLabel.font = UIFont.systemFont(ofSize: 34)
            super.init()
            
            cancellable = parent.playerVM.$isInPipMode
                .sink { [weak self] in
                    guard let self = self,
                          let controller = self.controller else { return }
                    if $0 {
                        if controller.isPictureInPictureActive == false {
                            controller.startPictureInPicture()
                        }
                    } else if controller.isPictureInPictureActive {
                        controller.stopPictureInPicture()
                    }
                }
            self.fireTimer()
        }
        
        func setController(_ playerLayer: AVPlayerLayer) {
            controller = AVPictureInPictureController(playerLayer: playerLayer)
            controller?.canStartPictureInPictureAutomaticallyFromInline = true
            controller?.delegate = self
            controller?.setValue(1, forKey: "controlsStyle")
        }
        
        func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            let window = UIApplication.shared.windows.first
            window?.addSubview(self.clockLabel)
            self.clockLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        }
        
        func fireTimer() {
            Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { Timer in
                self.parent.playerVM.clockText = self.getCurrentTime(date: Date()) ?? "Unknow"
                self.clockLabel.text = self.parent.playerVM.clockText

            }
        }
        
        func getCurrentTime(date:Date) -> String?{
            let formatter = DateFormatter()
            formatter.dateFormat = "H:mm:ss.SSSS"
            return formatter.string(from: date)
        }
        
        func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = true
        }
        
        func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = false
        }
    }
}
