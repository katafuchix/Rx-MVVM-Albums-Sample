//
//  Album.swift
//  Rx-MVVM-Albums-Sample
//
//  Created by cano on 2022/06/17.
//

import Foundation

struct Album: Codable {
    
    let id, name, albumArtWork, artist: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case albumArtWork = "album_art_work"
        case artist
    }
}


// MARK: Convenience initializers

extension Album {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Album.self, from: data) else { return nil }
        self = me
    }
}
