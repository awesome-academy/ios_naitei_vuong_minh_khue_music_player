//
//  ViewController.swift
//  MusicApp
//
//  Created by Khue on 13/07/2023.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var performerLabel: UILabel!
    @IBOutlet private weak var artworkImageView: UIImageView!
    @IBOutlet private weak var playTimeSlider: UISlider!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - Variable
    private var songs: [Song] = []
    private var position: Int = 0
    
    private var player = AVAudioPlayer()
    private var timer = Timer()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSongs()
        updateSong()
    }
    
    // MARK: - IBAction
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
    
    private func addSongs(){
        songs.append(Song(title: "Waiting For You", performer: "MONO, Onionn", artworkName: "WaitingForYou", songName: "WaitingForYou"))
        songs.append(Song(title: "để tôi ôm em bằng giai điệu này", performer: "Kai Đinh, MIN, GREY D", artworkName: "DeToiOmEmBangGiaiDieuNay", songName: "DeToiOmEmBangGiaiDieuNay"))
        songs.append(Song(title: "Chuyện Đôi Ta", performer: "Emcee L, Muộii", artworkName: "ChuyenDoiTa", songName: "ChuyenDoiTa"))
        songs.append(Song(title: "Waiting For You", performer: "MONO, Onionn", artworkName: "WaitingForYou", songName: "WaitingForYou"))
        songs.append(Song(title: "để tôi ôm em bằng giai điệu này", performer: "Kai Đinh, MIN, GREY D", artworkName: "DeToiOmEmBangGiaiDieuNay", songName: "DeToiOmEmBangGiaiDieuNay"))
        songs.append(Song(title: "Chuyện Đôi Ta", performer: "Emcee L, Muộii", artworkName: "ChuyenDoiTa", songName: "ChuyenDoiTa"))
    }
    
}

