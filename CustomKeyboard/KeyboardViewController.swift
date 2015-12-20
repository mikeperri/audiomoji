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
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var keys: [KeyData]!
    var hud: MBProgressHUD = MBProgressHUD()
    var audioPlayer: AVAudioPlayer!
    var bundle: NSBundle = NSBundle.mainBundle()
    
    var nextKeyboardButton: UIButton!
    var backspaceButton: UIButton!
    var audioButtonDict = Dictionary<Int, String>()

    override func viewDidLoad() {
        
        //TODO: load from plist
        keys = [KeyData]()
        keys.append(KeyData(text: "📣", audioResourceName: "airhorn"))
        keys.append(KeyData(text: "👏", audioResourceName: "applause"))
        keys.append(KeyData(text: "🍺", audioResourceName: "beer"))
        keys.append(KeyData(text: "💰", audioResourceName: "cash"))
        keys.append(KeyData(text: "🐱", audioResourceName: "cat"))
        keys.append(KeyData(text: "🔕", audioResourceName: "crickets"))
        keys.append(KeyData(text: "🐶", audioResourceName: "dog"))
        keys.append(KeyData(text: "🍐", audioResourceName: "huh"))
        keys.append(KeyData(text: "💩", audioResourceName: "peach"))
        keys.append(KeyData(text: "😹", audioResourceName: "rimshot"))
        keys.append(KeyData(text: "🚀", audioResourceName: "rocket"))
        keys.append(KeyData(text: "🐓", audioResourceName: "rooster"))
        keys.append(KeyData(text: "😿", audioResourceName: "sad-trombone"))
        keys.append(KeyData(text: "🚔", audioResourceName: "siren"))
        keys.append(KeyData(text: "🦃", audioResourceName: "turkey"))
        
        //Long press
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
            constant: 90
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let keyData = keys[indexPath.item]
        let progressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
        progressHUD.mode = MBProgressHUDMode.CustomView
        progressHUD.labelText = "Copied"
        progressHUD.hide(true, afterDelay: 1)
        
        pasteAudio(keyData.audioResourceName)
    }
    
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
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    //Action for next keyboard button
    @IBAction override func advanceToNextInputMode() {
        super.advanceToNextInputMode()
    }
    
    @IBAction func backspace() {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if let audioResourceName = audioButtonDict[sender.tag] {
            pasteAudio(audioResourceName)
        }
    }

    func pasteAudio(resourceName: String) {
        if let pasteboard: UIPasteboard = UIPasteboard.generalPasteboard() {
            if let path = NSBundle.mainBundle().pathForResource(resourceName, ofType: "amr") {
                if let amrData = NSData(contentsOfFile: path) {
                    let dict = NSMutableDictionary(capacity: 3)
                    dict.setValue("Audio Message.amr", forKey: "public.url-name")
                    dict.setValue("Audio Message.amr", forKey: "public.utf8-plain-text")
                    dict.setValue(amrData, forKey: "org.3gpp.adaptive-multi-rate-audio")
                    pasteboard.items = NSArray(object: dict) as [AnyObject]
                }
            }
        }
    }
}