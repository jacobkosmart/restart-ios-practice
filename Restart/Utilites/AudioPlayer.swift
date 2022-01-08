//
//  AudioPlayer.swift
//  Restart
//
//  Created by Jacob Ko on 2022/01/08.
//

import Foundation
// AV Foundation is a full-featured gramework for working with time-based audiovisualmedia
import AVFoundation

var audioPlayer: AVAudioPlayer?

// sound: file Name, type: File Extenstion
func playSound(sound: String, type: String) {
	if let path = Bundle.main.path(forResource: sound, ofType: type) {
		// return the full pathname for the resource.
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
			audioPlayer?.play()
		} catch {
			print("Could not play the sound file.")
		}
	}
}
