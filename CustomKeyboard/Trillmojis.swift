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
    var sendText: Bool
}

struct Trillmojis {
    static func get() -> [Trillmoji] {
        return [
            Trillmoji(text: "📣", audioResourceName: "airhorn", sendText: true),
            Trillmoji(text: "👏", audioResourceName: "applause", sendText: true),
            Trillmoji(text: "🍺", audioResourceName: "beer", sendText: true),
            Trillmoji(text: "💰", audioResourceName: "cash", sendText: true),
            Trillmoji(text: "🐱", audioResourceName: "cat", sendText: true),
            Trillmoji(text: "🔕", audioResourceName: "crickets", sendText: false),
            Trillmoji(text: "🐶", audioResourceName: "dog", sendText: true),
            Trillmoji(text: "🍐", audioResourceName: "huh", sendText: true),
            Trillmoji(text: "💩", audioResourceName: "peach", sendText: true),
            Trillmoji(text: "😹", audioResourceName: "rimshot", sendText: false),
            Trillmoji(text: "🚀", audioResourceName: "rocket", sendText: true),
            Trillmoji(text: "🐓", audioResourceName: "rooster", sendText: true),
            Trillmoji(text: "😿", audioResourceName: "sad-trombone", sendText: false),
            Trillmoji(text: "🚔", audioResourceName: "siren", sendText: false),
            Trillmoji(text: "🦃", audioResourceName: "turkey", sendText: true)
        ]
    }
}