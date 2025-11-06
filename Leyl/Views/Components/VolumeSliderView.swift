//
//  VolumeSliderView.swift
//  Leyl
//
//  Created by Abdelaziz Salah on 05/11/25.
//

import MediaPlayer
import SwiftUI

struct VolumeSliderView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.showsVolumeSlider = true
        volumeView.tintColor = UIColor.white.withAlphaComponent(0.5)
        volumeView.setVolumeThumbImage(UIImage(), for: .normal)
        return volumeView
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}
