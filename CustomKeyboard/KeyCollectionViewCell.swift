//
//  KeyCollectionViewCell.swift
//  Trillmoji
//
//  Created by Michael Perri on 12/4/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit

class KeyCollectionViewCell: UICollectionViewCell {

    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
