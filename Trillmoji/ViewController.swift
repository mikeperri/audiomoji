//
//  ViewController.swift
//  Trillmoji
//
//  Created by Michael Perri on 11/27/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stepsLabel: UILabel!
    var stepsString = "Open the Settings app\n"
            + "Go to General > Keyboard > Keyboards\n"
            + "Tap Add New Keyboard\n"
            + "Select Trillmoji to add it\n"
            + "Select Trillmoji from the added keyboards\n"
            + "Allow full access*\n"
            + "Try it in the Messages app**";

    @IBOutlet weak var fullAccessInfoLabel: UILabel!
    var fullAccessInfoString = "*Full access is required to paste to the clipboard. "
            + "Trillmoji does not connect to the Internet at any time.\n"
            + "**Trillmoji ONLY works in the Messages app."
    
    override func viewDidLoad() {
        let stepsAttributedString = NSMutableAttributedString(
            string: stepsString
        );
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 12;
        paragraphStyle.lineSpacing = 4;
        
        // bold "Settings"
        stepsAttributedString.addAttribute(
            NSFontAttributeName,
            value: UIFont.boldSystemFontOfSize(stepsLabel.font.pointSize),
            range: NSRange(location: 9, length: 8)
        );
        
        // bold "Add New Keyboard"
        stepsAttributedString.addAttribute(
            NSFontAttributeName,
            value: UIFont.boldSystemFontOfSize(stepsLabel.font.pointSize),
            range: NSRange(location: 63, length: 16)
        );
        
        // bold "Trillmoji" (1)
        stepsAttributedString.addAttribute(
            NSFontAttributeName,
            value: UIFont.boldSystemFontOfSize(stepsLabel.font.pointSize),
            range: NSRange(location: 87, length: 9)
        );
        
        // bold "Trillmoji" (2)
        stepsAttributedString.addAttribute(
            NSFontAttributeName,
            value: UIFont.boldSystemFontOfSize(stepsLabel.font.pointSize),
            range: NSRange(location: 114, length: 9)
        );
        
        stepsAttributedString.addAttribute(
            NSParagraphStyleAttributeName,
            value: paragraphStyle,
            range: NSRange(location: 0, length: stepsAttributedString.length)
        );
        
        stepsLabel.attributedText = stepsAttributedString;
        fullAccessInfoLabel.text = fullAccessInfoString;
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

