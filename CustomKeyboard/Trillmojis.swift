//
//  Trillmojis.swift
//  Trillmoji
//
//  Created by Michael Perri on 12/26/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import Foundation

struct Trillmoji {
    var text: String
    var audioResourceName: String
}

struct Trillmojis {
    static func get() -> [Trillmoji] {
        return [
            Trillmoji(text: "📣", audioResourceName: "airhorn"),
            Trillmoji(text: "👏", audioResourceName: "applause"),
            Trillmoji(text: "🍺", audioResourceName: "beer"),
            Trillmoji(text: "💰", audioResourceName: "cash"),
            Trillmoji(text: "🐱", audioResourceName: "cat"),
            Trillmoji(text: "🔕", audioResourceName: "crickets"),
            Trillmoji(text: "🐶", audioResourceName: "dog"),
            Trillmoji(text: "🍐", audioResourceName: "huh"),
            Trillmoji(text: "💩", audioResourceName: "peach"),
            Trillmoji(text: "😹", audioResourceName: "rimshot"),
            Trillmoji(text: "🚀", audioResourceName: "rocket"),
            Trillmoji(text: "🐓", audioResourceName: "rooster"),
            Trillmoji(text: "😿", audioResourceName: "sad-trombone"),
            Trillmoji(text: "🚔", audioResourceName: "siren"),
            Trillmoji(text: "🦃", audioResourceName: "turkey")
        ]
    }
}