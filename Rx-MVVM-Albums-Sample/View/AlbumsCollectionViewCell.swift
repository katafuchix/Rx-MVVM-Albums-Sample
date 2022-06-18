//
//  AlbumsCollectionViewCell.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/18.
//

import UIKit
import SDWebImage

class AlbumsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    func configure(_ album: Album) {
        self.clear()
        
        self.albumImage.sd_setImage(with: URL(string: album.albumArtWork))
        self.albumArtist.text = ""
        self.albumTitle.text = album.name
        self.backImageView.sd_setImage(with: URL(string: album.albumArtWork))
    }
    
    func clear() {
        self.albumImage.image = UIImage()
        self.albumArtist.text = ""
        self.albumTitle.text = ""
        self.backImageView.image = UIImage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
