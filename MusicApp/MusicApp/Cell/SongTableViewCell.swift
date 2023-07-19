//
//  MusicTableViewCell.swift
//  MusicApp
//
//  Created by Khue on 19/07/2023.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var performerLabel: UILabel!
    @IBOutlet private weak var artworkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSong(_ song: Song) {
        titleLabel.text = song.title
        performerLabel.text = song.performer
        artworkImageView.image = UIImage(named: song.artworkName)
    }
}
