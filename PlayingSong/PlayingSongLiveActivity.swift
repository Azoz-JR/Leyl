//
//  PlayingSongLiveActivity.swift
//  PlayingSong
//
//  Created by Abdelaziz Salah on 07/11/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PlayingSongLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PlayingSongAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 0) {
                SongLiveActivityView(
                    image: context.state.image,
                    title: context.state.title,
                    artist: context.state.artist
                )
                
                SongPlaybackView(state: context.state)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
            }
//            .glassEffect(.clear.tint(.white), in: .rect(corners: .concentric()))
//            .activityBackgroundTint(Color.cyan)
//            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Image(context.state.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50, alignment: .topLeading)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, 5)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(context.state.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(context.state.artist)
                            .foregroundStyle(.secondary)
                            .font(.system(size: 15, weight: .regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    SongPlaybackView(state: context.state)
//                        .padding(.bottom, 10)
                }
            } compactLeading: {
                Image(context.state.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } compactTrailing: {
                Image(systemName: "waveform")
                    .symbolColorRenderingMode(.gradient)
                    .symbolEffect(.bounce, options: .repeat(.continuous), isActive: true)
                    .foregroundStyle(.brown)
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

#Preview("Notification", as: .content, using: PlayingSongAttributes.preview) {
   PlayingSongLiveActivity()
} contentStates: {
    PlayingSongAttributes.ContentState.smiley
//    PlayingSongAttributes.ContentState.starEyes
}
