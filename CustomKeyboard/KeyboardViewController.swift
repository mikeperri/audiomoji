//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Michael Perri on 11/29/15.
//  Copyright © 2015 Michael Perri. All rights reserved.
//

import UIKit
import AVFoundation

class KeyboardViewController: UIInputViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet var collectionView: UICollectionView!
    //weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    let keys: [Trillmoji] = Trillmojis.get()
    let hud: MBProgressHUD = MBProgressHUD()
    let bundle: NSBundle = NSBundle.mainBundle()
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 1.0
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        view.addConstraint(NSLayoutConstraint(
            item: view,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 168
        ));
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! KeyCell
        let keyData = keys[indexPath.item]
        cell.label.text = keyData.text
        
        
        return cell
    }
    
    // Emoji was tapped
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        copyAudio(keys[indexPath.item])
    }
    
    func copyAudio(trillmoji: Trillmoji) {
        if let pasteboard: UIPasteboard = UIPasteboard.generalPasteboard() {
            if let path = NSBundle.mainBundle().pathForResource(trillmoji.audioResourceName, ofType: "amr") {
                if let amrData = NSData(contentsOfFile: path) {
                    let dict = NSMutableDictionary(capacity: 3)
                    dict.setValue("Audio Message.amr", forKey: "public.url-name")
                    dict.setValue("Audio Message.amr", forKey: "public.utf8-plain-text")
                    dict.setValue(amrData, forKey: "org.3gpp.adaptive-multi-rate-audio")
                    pasteboard.items = NSArray(object: dict) as [AnyObject]
                    
                    showHUD("Copied " + trillmoji.text)
                }
            }
        } else {
            showHUD("Please allow full access.")
        }
    }
    
    func showHUD(text: String) {
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
        progressHUD.mode = MBProgressHUDMode.CustomView
        progressHUD.labelText = text
        progressHUD.hide(true, afterDelay: 1)
    }
    
    // Emoji was held
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended || sender.state == UIGestureRecognizerState.Cancelled {
            audioPlayer?.stop()
        }
        
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.collectionView)
            
            if let indexPath = self.collectionView.indexPathForItemAtPoint(p) {
                let keyData = keys[indexPath.item]
                if let soundPath = bundle.pathForResource(keyData.audioResourceName, ofType: "wav") {
                    let soundURL = NSURL(fileURLWithPath: soundPath)
                    
                    do {
                        try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
                        audioPlayer.play()
                    } catch {}
                }
            }
        }
    }
    
    // Next keyboard button action
    @IBAction override func advanceToNextInputMode() {
        super.advanceToNextInputMode()
    }
    
    // Backspace button action
    @IBAction func backspace() {
        self.textDocumentProxy.deleteBackward()
    }
}