//
//  Key.swift
//  Trillmoji
//
//  Created by Michael Perri on 12/5/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import Foundation

class KeyData {
    var text: String
    var audioResourceName: String
    
    init(text: String, audioResourceName: String) {
        self.text = text
        self.audioResourceName = audioResourceName
    }
}