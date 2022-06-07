//
//  ContentView.swift
//  BTCompTest
//
//  Created by blacktea on 2022/6/6.
//

import SwiftUI
//        https://www.createwithswift.com/custom-video-player-with-avkit-and-swiftui-supporting-picture-in-picture/

struct ContentView: View {
    var body: some View {
        VStack{
            CustomPlayerWithControls()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
