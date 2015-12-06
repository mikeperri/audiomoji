//
//  KeyCollectionViewCell.swift
//  Trillmoji
//
//  Created by Michael Perri on 12/4/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit

class KeyCollectionViewCell: UICollectionViewCell {

    var label: UILabel!
    //var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        label.font = UIFont.systemFontOfSize(42)
        label.textAlignment = NSTextAlignment.Center
        contentView.addSubview(label)
        
        //imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        //imageView.contentMode = UIViewContentMode.ScaleAspectFill
        //contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
