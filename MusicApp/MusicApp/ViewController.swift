//
//  ViewController.swift
//  MusicApp
//
//  Created by Khue on 13/07/2023.
//

import UIKit
import AVFoundation
import MediaPlayer

final class ViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var performerLabel: UILabel!
    @IBOutlet private weak var artworkImageView: UIImageView!
    @IBOutlet private weak var playTimeSlider: UISlider!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    var songs: [Song] = []
    var position: Int = 0
    private var player = AVAudioPlayer()
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSong()
        setupRemoteCommandCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player.stop()
    }
    
    @IBAction private func pauseButtonTouchUpInside(_ sender: Any) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction private func nextButtonTouchUpInside(_ sender: Any) {
        if position < songs.count - 1 {
            position = position + 1
            updateSong()
        }
    }
    
    @IBAction private func backButtonTouchUpInside(_ sender: Any) {
        if position > 0 {
            position = position - 1
            updateSong()
        }
    }
    
    @IBAction private func sliderValueChanged(_ sender: Any) {
        let songDuration = player.duration
        
        player.currentTime = songDuration*Double(playTimeSlider.value)
        updateNowPlaying()
    }
    
    private func updateSong(){
        //Invalidate previous timer
        timer.invalidate()
        
        let currentSong = songs[position]
        titleLabel.text = currentSong.title
        performerLabel.text = currentSong.performer
        artworkImageView.image = UIImage(named: currentSong.artworkName)
        
        //Player Control
        backButton.alpha = position == 0 ? 0 : 1
        nextButton.alpha = position == songs.count - 1 ? 0 : 1
        
        //PlayTime Slider
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let currentPlayTime = Float(self.player.currentTime)
            let songDuration = Float(self.player.duration)
            
            self.playTimeSlider.value = currentPlayTime/songDuration
            
            if self.player.isPlaying {
                self.pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                self.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
        
        playSong(songName: currentSong.songName)
        updateNowPlaying()
    }
    
    private func updateNowPlaying() {
        let currentSong = songs[position]
        
        guard let artWorkImage = UIImage(named: currentSong.artworkName) else { return }
        let MPArtWork = MPMediaItemArtwork(boundsSize: artWorkImage.size) { [unowned artWorkImage] size in
            return artWorkImage
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: currentSong.performer,
            MPMediaItemPropertyTitle: currentSong.songName,
            MPMediaItemPropertyArtwork: MPArtWork,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime,
            MPMediaItemPropertyPlaybackDuration: player.duration,
            MPNowPlayingInfoPropertyPlaybackRate: player.rate
        ]
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }

    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] event in
            player.play()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            player.pause()
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget {  [unowned self] event in
            if position < songs.count - 1 {
                position = position + 1
                updateSong()
            }
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            if position > 0 {
                position = position - 1
                updateSong()
            }
            return .success
        }
    }
    
    private func playSong(songName: String) {
        if let url = Bundle.main.url(forResource: songName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.play()
            } catch {
                print("Cannot find \(songName)")
            }
        }
    }
}

