//
//  SongListViewController.swift
//  MusicApp
//
//  Created by Khue on 19/07/2023.
//

import UIKit

final class SongListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSongs()
        
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
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

// MARK: - UITableViewDataSource
extension SongListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightSongTableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as! SongTableViewCell
        cell.setSong(songs[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SongListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let playerVC = storyboard?.instantiateViewController(withIdentifier: "playerView") as! ViewController
        playerVC.songs = songs
        playerVC.position = indexPath.row
        
        present(playerVC, animated: true)
    }
}
