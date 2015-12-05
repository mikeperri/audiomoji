//
//  Key.swift
//  Trillmoji
//
//  Created by Michael Perri on 12/5/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import Foundation

class KeyData {
    var imageResourceName: String
    var audioResourceName: String
    
    init(imageResourceName: String, audioResourceName: String) {
        self.imageResourceName = imageResourceName
        self.audioResourceName = audioResourceName
    }
}