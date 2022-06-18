//
//  TracksTableViewCell.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/18.
//

import UIKit
import SDWebImage

class TracksTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImage : UIImageView!
    @IBOutlet weak var trackArtist : UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    
    func configure(_ track: Track) {
        self.clear()
        
        self.trackImage.clipsToBounds = true
        self.trackImage.layer.cornerRadius = 3
        self.trackImage.sd_setImage(with: URL(string: track.trackArtWork))
        self.trackTitle.text  = track.name
        self.trackArtist.text = track.artist
    }
    
    func clear() {
        self.trackImage.image = UIImage()
        self.trackTitle.text  = ""
        self.trackArtist.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
