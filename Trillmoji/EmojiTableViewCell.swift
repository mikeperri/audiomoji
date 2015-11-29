//
//  EmojiTableViewCell.swift
//  Old School Emoji
//
//  Created by Michael Perri on 11/27/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var emojiTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
